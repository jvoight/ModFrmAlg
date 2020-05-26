freeze;

/****-*-magma-**************************************************************
                                                                            
                    Algebraic Modular Forms in Magma                          
                            Eran Assaf                                 
                                                                            
   FILE: linalg.m (Linear Algbera)

   Implementation file for useful linear algebra functions.

   !!! TODO : move to the utils folder

   05/08/20 : Added functions for decomposition of the space (future use).

   04/08/20 : Modified to handle finite fields as well.

   04/01/20 : Started preparation to adjust for arbitrary characteristic.
              Not much of a change yet.

   03/26/20 : Added documentation to this file.

   03/26/20 : Fixed bug in Decompose - Optimized Representation only eats 
              absolute fields. (over the rationals)
 
 ***************************************************************************/

function Decompose(T, t)
    // The characteristic polynomial of this matrix.
    chi := CharacteristicPolynomial(T);
    
    // Factorization of the characteristic polynomial.
    fs := Factorization(chi);

    // The eigenspaces arising from this matrix.
    spaces := [* *];

    for data in fs do
	// Number field associated to one of the irreducible factors.
	
	K := ext< BaseRing(data[1]) | data[1] >;

	// The eigenvalue associated to this factor.
	if Degree(data[1]) eq 1 then
	    eig := -Evaluate(data[1], 0);
	else
	    eig := K.1;
	end if;

	// If the field K is not the rationals, try to optimize it as
	//  long as the degree of the field isn't too large.
	if Category(K) notin [FldRat,FldFin] and Degree(K) le 8 then
	    // Optimize the number field.
	    K, map := OptimizedRepresentation(AbsoluteField(K));
	    
	    // The eigenvalue in the new field.
	    eig := map(eig);
	end if;
	
	// The identity matrix of the appropriate dimension.
	id := Id(MatrixRing(K, Nrows(t)));
	
	// Promote the ambient matrix to the current number field.
	tt := ChangeRing(t, K);
	

	
	if Characteristic(BaseRing(T)) eq 0 then
	    fT := tt-eig*id;
	else
	    fT := (tt-eig*id)^data[2];
	end if;

	Append(~spaces,
	       < Nullspace(fT), data[2] eq 1 >);
    end for;
    
    return spaces;
end function;

intrinsic EigenspaceDecomposition(array::Assoc : Warning := true)
	-> List, SeqEnum
{ Decompose an array of mutually commuting matrices into their eigenspaces. }
  // Make sure that the associative array is non-empty.
  require #array ne 0: "Associative array must not be empty.";

  // Extract the keys associated to the associative array.
  keys := Keys(array);

  // Put keys into an enumerative array.
  keys := [ x : x in keys ];

  // Extract the full list of matrices.
  Ts := [ array[x] : x in keys ];

  // Verify that all matrices mutually commute.
  require &and[ A*B eq B*A : A,B in Ts ]:
	"Matrices in array do not mutually commute.";

  // List of eigenspaces for the first matrix.
  sp := Decompose(Ts[1], Ts[1]);

  for idx in [2..#Ts] do
      // If all eigenspaces are irreducible, we're done.
      if &and[ data[2] : data in sp ] then break; end if;
      
      // The number of eigenspaces we are starting with.
      num := #sp;
      
      // Keep track of the eigenspaces we'll need to delete.
      delList := [];
      
      for i in [1..num] do
	  // Skip this eigenspace if it is irreducible.
	  if sp[i][2] then continue; end if;
	  
	  // Add the current eigenspace to the delete list.
	  Append(~delList, i);
	  
	  // The current subspace.
	  space := sp[i][1];

	  // something here doesn't look right - maybe it only works in characteristic 0 ?
	  // In any case the resulting matrix T is not the submatrix associated to this subspace
	  
	  
	  // Dimension of this space.
	  dim := Dimension(space);

	  B := BasisMatrix(space);
	  tempT := ChangeRing(Ts[idx], BaseRing(space));
	  T := Matrix(B*tempT*Transpose(B)*(B * Transpose(B))^(-1));
	  
	  
	  // Compute the eigenspaces associated to T.
	  newSpaces := Decompose(T, Ts[idx]);
	  
	  for newSp in newSpaces do
	      // The field over which both spaces live.
	      if Type(BaseRing(space)) eq FldFin then
		  deg := LCM(Degree(BaseRing(space)),
			     Degree(BaseRing(newSp[1])));
		  F := FiniteField(
			       Characteristic(BaseRing(space)), deg);
	      else
		  F := CompositeFields(
			       BaseRing(newSp[1]), BaseRing(space))[1];
	      end if;
	      
	      // Compute the intersection of these two spaces
	      //  and add it to the list.
	      Append(~sp, < ChangeRing(newSp[1], F)
				      meet ChangeRing(space, F), newSp[2] >);
	  end for;
      end for;

      // Remove the outdated subspaces from last to first.
      sp := [* sp[i] : i in [1..#sp] | not i in delList *];
      
      assert &+[ Dimension(s[1]) * Degree(BaseRing(s[1])) : s in sp ]
	     eq Nrows(Ts[1]) * Degree(BaseRing(Ts[1]));
  end for;

  // Determine whether this decomposition is stll decomposable.
  decomposable := [ i : i in [1..#sp] | not sp[i][2] ];
  
  // Return the eigenspaces.
  sp := [* data[1] : data in sp *];

  // Display a warning if the decomposition is reducible.
  if Warning and #decomposable ne 0 then
      print "WARNING: Eigenspaces not completely decomposed!";
  end if;

  return sp, decomposable;
end intrinsic;

// functions copied (and modified) from ModSym to do decomposition

function MyCharpoly(A, proof)
   assert Nrows(A) gt 0;
   if Type(BaseRing(Parent(A))) eq FldRat then
      return CharacteristicPolynomial(A : Al := "Modular", Proof:=proof);
   end if;
   return CharacteristicPolynomial(A);
end function;

function Restrict(A, x)
   F := BaseRing(Parent(A));
   if Type(x) eq SeqEnum then
      B := Matrix(F, x);
   else
      assert Type(x) in {ModTupRng, ModTupFld};
      if Dimension(x) eq 0 then
         return MatrixAlgebra(F,0)!0;
      end if;
      B := Matrix(F, BasisMatrix(x));
   end if; 
   R := MatrixAlgebra(F, Nrows(B)) ! Solution(B, B*A);
   return R;
end function;

function KernelOn(A, B)
// Suppose B is a basis for an n-dimensional subspace
// of some ambient space and A is an nxn matrix.
// Then A defines a linear transformation of the space
// spanned by B.  This function returns the
// kernel of that transformation.
   if Type(B) eq ModTupFld then
      BM := BasisMatrix(B);
   else
      BM := Matrix(B);
   end if;
   return RowSpace(KernelMatrix(A) * BM);
end function;

function SimpleIrreducibleTest(W,a)

   // a is the exponent of the factor of the charpoly.
   
    if a eq 1 then
	return true;
    end if;
    
    return false;
    
end function;

function W_is_irreducible(M,W,a,random_operator_bound :
			  estimate := true, orbits := true, useLLL := true)
   /*
   W = subspace of the dual
   a = exponent of factor of the characteristic polynomial.
   */

   irred := SimpleIrreducibleTest(W,a);

   if irred then
      return true;
   end if;

   if random_operator_bound gt 1 then
      if IsVerbose("AlgebraicModularForms") then 
         printf "Trying to prove irreducible using random sum of Hecke operators.\n";
      end if;
      T := &+[Random([-3,-2,-1,1,2,3])*Restrict(HeckeOperator(M,ell :
						Estimate := estimate,
						Orbits := orbits,
						UseLLL := useLLL), W) : 
                ell in PrimesUpTo(random_operator_bound, BaseRing(M))];
      f := CharacteristicPolynomial(T);
      if IsVerbose("AlgebraicModularForms") then 
         printf "Charpoly = %o.\n", f;
      end if;
      if IsIrreducible(f) then
         return true;
      end if;
   end if;

   return false;  

end function;

function Decomposition_recurse(M, V, primes, prime_idx,
                               proof, random_op :
			       useLLL := true, estimate := true, orbits := true)

   assert Type(M) eq ModFrmAlg;
   assert Type(primes) eq SeqEnum;
   assert Type(proof) eq BoolElt;
   assert Type(random_op) eq BoolElt;

   // Compute the Decomposition of the subspace V of M
   // starting with Tp.
   if Dimension(V) eq 0 then
      return [];
   end if;

   if prime_idx gt #primes then
       return [V];
   end if;
   
   fac := Factorization(ideal<Integers(BaseRing(M))|
			     Generators(primes[prime_idx])>);
   // if the prime is ramified, at the moment the Hecke Operator
   // is not computed correctly
   if (#fac eq 1) and (fac[1][2] eq 2) then
       return Decomposition_recurse(M, V, primes, prime_idx+1, proof,
				    random_op : useLLL := useLLL,
						estimate := estimate,
						orbits := orbits);
   end if;

   pR := fac[1][1];

   vprintf AlgebraicModularForms, 1 : "Decomposing space of dimension %o using T_%o.\n", Dimension(V), Norm(pR);
   vprintf AlgebraicModularForms, 2 : "\t\t(will stop at %o)\n",
				      Norm(primes[#primes]);

   T := Restrict(HeckeOperator(M, pR : Estimate := estimate,
				      Orbits := orbits, UseLLL := useLLL), V);
   D := [* *];

   
   if GetVerbose("AlgebraicModularForms") ge 2 then
       t := Cputime();
       printf "Computing characteristic polynomial of T_%o.\n", Norm(pR);
   end if;
   f := MyCharpoly(T,proof);
   if GetVerbose("AlgebraicModularForms") ge 2 then
       f;
       printf "\t\ttime = %o\n", Cputime(t);
       t := Cputime();
       printf "Factoring characteristic polynomial.\n";
   end if;
   FAC := Factorization(f);
   if GetVerbose("AlgebraicModularForms") ge 2 then
       FAC;
       printf "\t\ttime = %o\n", Cputime(t);
   end if;

   for fac in FAC do
      f,a := Explode(fac);
      if Characteristic(BaseRing(M)) eq 0 then
         fa := f;
      else
         fa := f^a;
      end if;
      vprintf AlgebraicModularForms, 2: "Cutting out subspace using f(T_%o), where f=%o.\n",Norm(pR), f;
      fT  := Evaluate(fa,T);
      W   := KernelOn(fT,V);

      if Dimension(W) eq 0 then
          error "WARNING: dim W = 0 factor; shouldn't happen.";
      end if;

      if Characteristic(BaseRing(M)) eq 0 and
	 W_is_irreducible(M,W,a,random_op select Norm(pR) else 0 :
			  estimate := estimate, orbits := orbits,
			  useLLL := useLLL) then
	 W_irred := true;
         Append(~D,W); 
      else
         if not assigned W_irred then
             if prime_idx lt #primes then
		 q_idx   := Dimension(W) eq Dimension(V) select
			    prime_idx + 1 else 1;
		 Sub  := Decomposition_recurse(M, W, primes, q_idx, 
                                               proof, random_op :
					       useLLL := useLLL,
					       orbits := orbits,
					       estimate := estimate); 
               for WW in Sub do 
                  Append(~D, WW);
               end for;
            else
               Append(~D,W);
            end if;
         end if;
      end if;
   end for;
   return D;
end function;

procedure SortDecomp(~D)
    dims := [< Dimension(D[i]) * Degree(BaseField(D[i])), i > : i in [1..#D]]; 
    Sort(~dims);
    D := [D[tup[2]] : tup in dims];
end procedure;

intrinsic Decomposition(M::ModFrmAlg, bound::RngIntElt :
			useLLL := true,
			orbits := true,
			estimate := true,
			Proof := true) -> SeqEnum
{Decomposition of M with respect to the Hecke operators T_p with
p coprime to the level of M and p<= bound. }

   if Dimension(M) eq 0 then
      return [];
   end if;

   if not assigned M`Hecke`decomposition then   

      RF := recformat <
      bound  : RngIntElt, // bound so far
      decomp : List    // subspace of M
      >;

      D := [* VectorSpace(M) *];

      M`Hecke`decomposition := rec < RF | bound := 0, decomp := D>;
   end if;

   decomp := (M`Hecke`decomposition)`decomp;
   known  := (M`Hecke`decomposition)`bound;
   if bound le known then
      SortDecomp(~decomp);
      return decomp;
   end if;

   // refine decomp
   alpha := Involution(AmbientSpace(Module(M)));
   F := FixedField(alpha);
   primes := PrimesUpTo(bound, F:
			coprime_to := Numerator(Norm(Discriminant(Module(M)))));
   prime_idx := [i : i in [1..#primes] | Norm(primes[i]) gt known][1];
   refined_decomp := &cat[Decomposition_recurse(M,MM, primes, prime_idx,
						Proof, false :
						useLLL := useLLL,
						orbits := orbits,
						estimate := estimate) :
                          MM in decomp];
         
   (M`Hecke`decomposition)`bound := bound;
   (M`Hecke`decomposition)`decomp := refined_decomp;

   SortDecomp(~refined_decomp);
   return refined_decomp;
end intrinsic;

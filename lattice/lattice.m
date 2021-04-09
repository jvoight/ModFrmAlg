freeze;
/****-*-magma-******a********************************************************
                                                                            
                        Algebraic Modular Forms in Magma
                        
                  E. Assaf, M. Greenberg, J. Hein, J.Voight
         using lattices over number fields by M. Kirschmer and D. Lorch         
                   
   FILE: lattice.m

   Implementation file for lattice routines

   05/29/2020 : Fixed a bug in IsIntegral - used to work only for orthogonal
                and not for hermitian.

   05/26/2020 : Modified Scale and Norm to match the 
   	      	definitions in Kirschmer's thesis.
                Modified AuxForms and ZLattice to return the lattice and the
                forms multiplied by 2, since now we are allowing lattices 
		and forms with non-integral coefficients, so these might be
                half-integral and the code handling lattices over Z only accepts
                integral coefficients.
                Also modified pMaximalGram in the same manner, so that we will
                be able to reduce modulo p, even when p divides 2.
                Modified Discriminant to match the definition in [GV].
                Added and adapted code from Kirschmer's package to check
                for integrality of lattices, to find a maximal integral lattice

   04/27/2020 : Modified AutomorphismGroup to work also for SO 
   	      	(parameter special)
                Fixed bug in IsIsometric when special = true.
                Removed restriction of positive-definite, as now we also use
                this module for construction of indefinite groups.

   04/24/2020 : Modified default values of BeCareful to be false.
                Modified IsIsometric to have a parameter, indicating a special 
		isometry.
 
   04/20/2020 : Modified LatticeWithBasis to handle bases given as a nonsquare 
                matrix, and fixed a bug in PullUp.

   03/05/2020 : Created this file as a copy of the one from othogonal package.
                Replaced quadratic spaces by reflexive spaces.
                Added a GramMatrix intrinsic, as it repeats in many places.
                Made appropriate adjustments to discriminant, auxiliary forms, 
                and Gram matrix for the unitary case.
 
 ***************************************************************************/

// Here we list the intrinsics that this file defines
// Parent(lat::ModDedLat)
// Print(lat::ModDedLat, level::MonStgElt)
// 'eq'(lat1::ModDedLat, lat2::ModDedLat) -> BoolElt
// ReflexiveSpace(L::ModDedLat) -> RfxSpace
// AmbientSpace(L::ModDedLat) -> RfxSpace
// Module(L::ModDedLat) -> ModDed
// PseudoBasis(L::ModDedLat) -> SeqEnum
// BaseRing(L::ModDedLat) -> RngOrd
// StandardLattice(rfxSpace::RfxSpace) -> ModDedLat
// LatticeWithBasis(rfxSpace::RfxSpace, basis::Mtrx) -> ModDedLat
// LatticeFromLat(L::Lat) -> ModDedLat
// Dimension(L::ModDedLat) -> RngIntElt
// LatticeWithBasis(rfxSpace::RfxSpace, basis::AlgMatElt, idls::SeqEnum) -> ModDedLat
// LatticeWithPseudobasis(rfxSpace::RfxSpace, pmat::PMat) -> ModDedLat
// ZLattice(lat::ModDedLat) -> Lat
// AuxForms(lat::ModDedLat) -> SeqEnum
// Discriminant(lat::Lat) -> RngInt
// Level(lat::ModDedLat) -> RngOrdFracIdl
// Divisor(lat::ModDedLat) -> RngOrdFracIdl
// Trace(p::RngOrdFracIdl, a::FldAut) -> RngOrdFracIdl
// Norm(p::RngOrdFracIdl, a::FldAut) -> RngOrdFracIdl
// Norm(lat::ModDedLat) -> RngOrdFracIdl
// GramMatrix(lat::ModDedLat, vecs::SeqEnum) -> AlgMatElt
// Scale(lat::ModDedLat) -> RngOrdFracIdl
// ElementaryDivisors(lambda::ModDedLat, pi::ModDedLat) -> SeqEnum
// Discriminant(lambda::ModDedLat, pi::ModDedLat) -> RngOrdFracIdl
// Discriminant(lat::ModDedLat) -> RngOrdFracIdl
// IntersectionLattice(lat1::ModDedLat, lat2::ModDedLat) -> ModDedLat
// Index(lat1::ModDedLat, lat2::ModDedLat) -> RngOrdFracIdl
// IsIsometric(lat1::ModDedLat, lat2::ModDedLat) -> BoolElt, Mtrx
// AutomorphismGroup(lat::ModDedLat) -> SeqEnum
// IsFree(L::ModDedLat) -> BoolElt
// FreeBasis(L::ModDedLat) -> SeqEnum
// PullUp(g::AlgMatElt, Lambda::ModDedLat, Pi::ModDedLat) -> AlgMatElt
// DualLattice(L::ModDedLat) -> ModDedLat
// '*'(a::RngOrdFracIdl, L::ModDedLat) -> ModDedLat
// 'subset'(lambda::ModDedLat, pi::ModDedLat) -> BoolElt
// DualLattice(L::ModDedLat, a::RngOrdFracIdl) -> ModDedLat
// Rank(L::ModDedLat) -> RngIntElt
// IsZero(L::ModDedLat) -> BoolElt
// Degree(L::ModDedLat) -> RngIntElt
// IsFull(L::ModDedLat) -> BoolElt
// InnerProductMatrix(L::ModDedLat) -> Mtrx
// MyEvenHilbertSymbol(a::FldElt,b::FldElt,p::RngOrdIdl) -> RngIntElt
// MyHilbertSymbol(a::FldAlgElt, b::FldAlgElt, p::RngOrdIdl) -> RngIntElt
// WittInvariant(L::ModDedLat, p::RngOrdIdl) -> RngIntElt
// Lattice(V::RfxSpace, L::ModDed) -> ModDedLat
// LocalBasis(M::ModDed, p::RngOrdIdl) -> []
// IsIntegral(L::ModDedLat, p::RngOrdIdl) -> BoolElt
// IsIntegral(L::ModDedLat) -> BoolElt
// IsMaximalIntegral(L::ModDedLat, p::RngOrdIdl) -> BoolElt, ModDedLat
// BadPrimes(L::ModDedLat) -> []
// IsMaximalIntegral(L::ModDedLat) -> BoolElt, ModDedLat
// MaximalIntegralLattice(L::ModDedLat, p::RngOrdIdl) -> ModDedLat
// MaximalIntegralLattice(L::ModDedLat) -> ModDedLat
// MaximalIntegralLattice(V::RfxSpace) -> ModDedLat
// QuadraticFormInvariants(M::AlgMatElt) -> FldAlgElt, SetEnum, SeqEnum
// JordanDecomposition(L::ModDedLat, p::RngOrdIdl) -> []
// Ideal(R::RngPad, t::.) -> RngPadIdl
// Generators(I::RngPadIdl) -> SeqEnum
// Print(I::RngPadIdl)
// '#'(I::RngPadIdl) -> RngIntElt
// Module(R::RngPad, n::RngIntElt) -> ModPad
// pAdicModule(S::SeqEnum[ModTupFldElt]) -> ModPad
// Print(L::ModPad)
// '.'(L::ModPad, n::RngIntElt) -> ModTupFldElt
// 'in'(v::ModTupFldElt, L::ModPad) -> BoolElt
// ChangeRing(L::ModPad, R::RngPad) -> ModPad
// DirectSum(Ls::SeqEnum[ModPad]) -> ModPad
// 'subset'(L1::ModPad, L2::ModPad) -> BoolElt
// 'eq'(L1::ModPad, L2::ModPad) -> BoolElt
// Complete(L::ModDed, p::RngOrdIdl) -> ModPad
// Complete(L::ModDedLat, p::RngOrdIdl) -> ModPad

///////////////////////////////////////////////////////////////////
//                                                               //
//    ModDedLat: The lattice in a Dedekind module object.        //
//                                                               //
///////////////////////////////////////////////////////////////////

declare type ModDedLat;
declare attributes ModDedLat:
	// The lattice.
	Module,

	// The base ring.
	R,

	// The base field.
	F,

	// The pseudobasis (only used when not over the rationals).
	psBasis,

        // The ambient reflexive space
        rfxSpace,
  
	// The discriminant ideal.
	Discriminant,

	// The p-maximal basis is not strictly-speaking a basis for the lattice,
	//  but instead a basis for the completed lattice at p. This is used to
	//  compute the affine reflexive space and thereby compute isotropic
	//  lines, etc.
	pMaximal,

	// The lattice pushed down to the integers. This is the same as L if
	//  and only if the base field is the rationals.
	ZLattice,

	// The automorphism group as a lattice over Z.
	AutomorphismGroup,

	// The special automorphism group as a lattice over Z.
	SpecialAutomorphismGroup,

	// The scale of the lattice.
	Scale,

	// The norm of the lattice.
	Norm,

	// The level of the lattice.
	Level,

	// An associative array storing reflexive spaces modulo primes.
	Vpp,

	// Jordan decomposition of the lattice at a prime.
	Jordan,

	// The spinor norms at specified prime ideals.
	SpinorNorm;

// adding some attributes to the existing lattice type Lat.

declare attributes Lat:
	// The auxiliary forms associated to this lattice.
	auxForms,

	// The basis of the lattice with coefficients in R.
	basisR,

	// The basis of the lattice with coefficients in Z.
	basisZ,

	// An associative array storing quadratic spaces modulo primes
	Vpp;

// Implementation of lattice routines.

intrinsic Parent(lat::ModDedLat) {}
  PowerStructure(ModDedLat);
end intrinsic;

// print

intrinsic Print(lat::ModDedLat, level::MonStgElt) {}
   if level eq "Magma" then
     pb := PseudoBasis(lat);
     idls := [x[1] : x in pb];
     basis := Matrix([x[2] : x in pb]);
     V := ReflexiveSpace(lat);
     printf "LatticeWithBasis(%m, %m, %m)", V, basis, idls;
     return;
   end if;

   if (SpaceType(ReflexiveSpace(lat)) eq "Hermitian") then
     factor := 1;
     disc := "discriminant";
     half := false;
   else
     factor := 2;
     if IsEven(Rank(lat)) then
       disc := "discriminant";
       half := false;
     else
       disc := "half-discriminant";
       half := true;
     end if;
   end if;
   
   printf "lattice whose %o has norm %o", disc,
     Norm(Discriminant(lat : GramFactor := 2, Half := half));
   if level eq "Maximal" then
     printf "%o", Module(lat);
   end if;
end intrinsic;

// boolean operators

intrinsic 'eq'(lat1::ModDedLat, lat2::ModDedLat) -> BoolElt
{ Determine whether two lattices are equal. }
	return ReflexiveSpace(lat1) eq ReflexiveSpace(lat2) and
		Module(lat1) eq Module(lat2);
end intrinsic;

// access

intrinsic ReflexiveSpace(L::ModDedLat) -> RfxSpace
{ Returns the reflexive space of the lattice. }
	return L`rfxSpace;
end intrinsic;

intrinsic AmbientSpace(L::ModDedLat) -> RfxSpace
{ Returns the ambient reflexive space of the lattice. }
        return L`rfxSpace;
end intrinsic;

intrinsic Module(L::ModDedLat) -> ModDed
{ Returns the underlying module associated to this structure. }
	return L`Module;
end intrinsic;

intrinsic PseudoBasis(L::ModDedLat) -> SeqEnum[Tup]
{ Returns the pseudobasis for the underlying module structure. }
	return L`psBasis;
end intrinsic;

intrinsic BaseRing(L::ModDedLat) -> RngOrd
{ Returns the base ring of the lattice. }
	return L`R;
end intrinsic;

intrinsic StandardLattice(rfxSpace::RfxSpace) -> ModDedLat
{ Builds the standard lattice for the given reflexive space. }
// Return the standard lattice for this space if it has already been
//  computed.
  if assigned rfxSpace`stdLat then return rfxSpace`stdLat; end if;

  // The standard basis.
  basis := Id(MatrixRing(BaseRing(rfxSpace), Dimension(rfxSpace)));
  
  // Build the standard lattice.
  L := LatticeWithBasis(rfxSpace, basis);
	
  require IsIntegral(L) :
		    "Standard Lattice is not integral for reflexive space!" ; 

  // Assign the ZLattice.
  L`ZLattice := ZLattice(L : Standard := true);
  
  return L;
end intrinsic;

intrinsic LatticeWithBasis(rfxSpace::RfxSpace, basis::Mtrx) -> ModDedLat
{ Construct the lattice with the specified basis given by the rows of the
matrix provided. }
  // Make sure that the base ring of the reflexive space and the base
  //  ring of the supplied basis agree.
  // require BaseRing(rfxSpace) eq BaseRing(basis): "The base rings do not match.";
  iso, phi := IsIsomorphic(BaseRing(rfxSpace), BaseRing(basis));
  require iso : "The base rings do not match.";
  basis := ChangeRing(basis, BaseRing(rfxSpace));

  // Initialize the internal lattice structure.
  lat := New(ModDedLat);

  // Assign the base field.
  lat`F := BaseRing(rfxSpace);

  // Assign the base ring.
  lat`R := Integers(lat`F);

  // Assign the specified lattice.
  lat`Module := Module(Rows(basis));

  // Assign the pseudobasis if we're over a number field.
  lat`psBasis := PseudoBasis(Module(lat));

  // Assign the ambient reflexive space.
  lat`rfxSpace := rfxSpace;

  // Assign an empty associative array.
  lat`Vpp := AssociativeArray();

  // Assign an empty associative array.
  lat`Jordan := AssociativeArray();
  
  return lat;
end intrinsic;

intrinsic LatticeFromLat(L::Lat : GramFactor := 1) -> ModDedLat
{ Builds a ModDedLat structure from a native Lat structure. }
  // The inner form.
  innerForm := (1/GramFactor) * InnerProductMatrix(L);

  // The ambient reflexive space.
  Q := AmbientReflexiveSpace(innerForm);

  // The basis for the lattice.
  basis := ChangeRing(Matrix(Basis(L)), BaseRing(Q));

  // Build the lattice and return it.
  return LatticeWithBasis(Q, basis);
end intrinsic;

intrinsic Dimension(L::ModDedLat) -> RngIntElt
{ The dimension of the lattice. }
  return Dimension(ReflexiveSpace(L));
end intrinsic;

intrinsic LatticeWithBasis(
	rfxSpace::RfxSpace, basis::AlgMatElt[Fld], idls::SeqEnum)
		-> ModDedLat
{ Builds a lattice in an ambient reflexive space with the specified basis and
coefficient ideals. }
  // The dimension.
  dim := Dimension(rfxSpace);

  // Initialize the lattice data.
  lat := New(ModDedLat);

  // Assign the basic properties.
  lat`rfxSpace := rfxSpace;
  lat`F := BaseRing(rfxSpace);
  lat`R := Integers(lat`F);

  basis := ChangeRing(basis, lat`F);
  idls := [lat`F!!I : I in idls];

  // Build the lattice.
  lat`Module := Module(PseudoMatrix(idls, basis));

  // The pseudobasis.
  lat`psBasis := PseudoBasis(lat`Module);

  // The associative array of affine reflexive spaces.
  lat`Vpp := AssociativeArray();

  // The associative array of Jordan decompositions.
  lat`Jordan := AssociativeArray();

  return lat;
end intrinsic;

intrinsic LatticeWithPseudobasis(rfxSpace::RfxSpace, pmat::PMat) -> ModDedLat
{ Construct the lattice given a pseudomatrix. }
  // Build the module.
  module := Module(pmat);

  // Extract the basis.
  basis := Matrix(Basis(module));

  // Extract the coefficient ideals.
  idls := [ pb[1] : pb in PseudoBasis(module) ];

  return LatticeWithBasis(rfxSpace, basis, idls);
end intrinsic;

intrinsic ZLattice(lat::ModDedLat : Standard := false) -> Lat
{ Push the lattice down to the integers. }
  
  // If we've already computed the ZLattice, return it.
  if assigned lat`ZLattice then return lat`ZLattice; end if;

  V := VectorSpace(ReflexiveSpace(lat));

  // Construct an R-basis for the lattice as a Z-module.
  basisR := &cat[ [ V!(x*pb[2]) : x in Basis(pb[1]) ]
		: pb in PseudoBasis(Module(lat)) ];

  // Construct a Z-basis for the lattice as a Z-module.
  basisZ := Matrix([ &cat[ Eltseq(e) : e in Eltseq(b) ] : b in basisR ]);

  if Standard then
      // Build lattice as a Z-module in a rational quadratic space.
      lat`ZLattice := LatticeWithBasis(basisZ);

      // Assign the bases for this lattice.
      lat`ZLattice`basisR := basisR;
      lat`ZLattice`basisZ := basisZ;

      // Compute the auxiliary forms.
      auxForms := AuxForms(lat : Standard := Standard);
      
      // Assign the ambient inner form associated to this lattice.
      gram := auxForms[1];
  else
      // Assign the ambient inner form associated to this lattice.
      gram := lat`rfxSpace`stdLat`ZLattice`auxForms[1];
  end if;

  // Construct the ZLattice with basis in the correct quadratic space.
  lat`ZLattice := LatticeWithBasis(basisZ, ChangeRing(gram, Rationals())
				   : CheckPositive := false);

  // Assign the bases for the ZLattice.
  lat`ZLattice`basisR := basisR;
  lat`ZLattice`basisZ := basisZ;

  if Standard then
      lat`ZLattice`auxForms := AuxForms(lat : Standard := Standard);
  end if;

  return lat`ZLattice;
end intrinsic;

intrinsic AuxForms(lat::ModDedLat : Standard := false) -> SeqEnum
{ Compute the auxiliary forms associated to this lattice. }
  // Assign the ZLattice attribute if not yet assigned.
  if not assigned lat`ZLattice then
      lat`ZLattice := ZLattice(lat : Standard := Standard);
  end if;

  // As long as this isn't intended to become a standard lattice, return
  //  the auxiliary forms if they've already been computed.
  if not Standard and assigned lat`ZLattice`auxForms then
      return lat`ZLattice`auxForms;
  end if;

  // The base ring.
  R := BaseRing(lat);

  // The reflexive space associated to this lattice.
  V := ReflexiveSpace(lat);

  // The dimension.
  dim := Dimension(ReflexiveSpace(lat));

  // The degree of the field extension.
  deg := Degree(BaseRing(V));

  // The inner form of the ambient reflexive space.
  M := InnerForm(V);
  alpha := Involution(V);

  // The basis for the lattice over the rationals.
  basis := ZLattice(lat)`basisR;
  conj_basis := [alpha(b) : b in basis];

  // Compute a sequence of auxiliary pairings used to compute isometry
  //  of lattices over number field.
  phis := [ Matrix(deg*dim, deg*dim,
		   [ Trace((Matrix(z*x) * M * Transpose(Matrix(y)))[1,1])
		     : x in basis, y in conj_basis ]) : z in Basis(R) ];

  // Make sure that the lattice was pushed down to an integral one, and
  //  that the first bilinear pairing is symmetric and positive definite.
  // We no longer make sure of the conditions in the second line.
  try
      phis := [ ChangeRing(2*phi, Integers()) : phi in phis ];
      // !! TODO : in char. 2 check that we are alternating.
      assert Transpose(phis[1]) in [phis[1], -phis[1]];
      // We are now also using this function for symplectic groups  
      // assert IsSymmetric(phis[1]);
      // We are now using this function also to construct groups
      // corresponding to non-definite forms
      // assert IsPositiveDefinite(phis[1]);
  catch e
      require false: "Auxiliary forms are not of the correct form!";
  end try;
  
  return phis;
end intrinsic;

intrinsic Discriminant(lat::Lat) -> RngInt
{ Compute the discriminant ideal of the lattice. }
  // The dimension.
  dim := Dimension(lat);

  // Correction factor.
  factor := dim mod 2 eq 1 select 2 else 1;
  
  // The determinant of the lattice.
  det := Determinant(lat);

  return ideal< Integers() | det / factor >;
end intrinsic;

function pMaximalGram(L, pR : BeCareful := false, given_coeffs := [])
    if assigned L`pMaximal then
	// If the p-maximal data has been assigned, return it.
	if IsDefined(L`pMaximal, pR) then
	    return L`pMaximal[pR][1], L`pMaximal[pR][2];
	end if;
    else
	// If it consists of an empty array, create it.
	L`pMaximal := AssociativeArray();
    end if;

    // The coefficient ideals for this lattice.
    idls := [ pb[1] : pb in PseudoBasis(Module(L)) ];

    // The pseudobasis vectors.
    basis := Basis(Module(L));
    
    // Find a p-maximal basis.
    vecs := [];
    
    for i in [1..#idls] do
	// The generators of the coefficient ideal.
	gens := Generators(idls[i]);
	
	// Randomly choose a p-maximal vector.
	repeat
	    if IsEmpty(given_coeffs) then
		coeffs := [Random(11) - 5 : g in gens];
	    else
		coeffs := given_coeffs[i];
	    end if;
	    
            vec := &+[ gens[j] * coeffs[j] :
		       j in [1..#gens]] * basis[i];
	until not vec in pR * Module(L);
	// for debugging
	if GetVerbose("AlgebraicModularForms") ge 3 then
	    printf "coeffs = %o\n", coeffs;
	end if;
	// Verify that the vectors were chosen properly.
	if BeCareful then
	    assert vec in Module(L) and not vec in pR * Module(L);
	end if;
	
	// Add this vector to the list.
	Append(~vecs, vec);
    end for;
    
    gram := GramMatrix(L, vecs);
    
    // Store the p-maximal basis for future use.
    L`pMaximal[pR] := < ChangeRing(2*gram, BaseRing(L)), Matrix(vecs) >;
    
    // Return the Gram matrix and the basis.
    return L`pMaximal[pR][1], L`pMaximal[pR][2];
end function;

intrinsic Level(lat::ModDedLat) -> RngOrdFracIdl
{ Compute the level of the lattice. }
  // If the level has been computed, return it.
  if assigned lat`Level then return lat`Level; end if;

  // The coefficient ideals of the dual.
  idls := [ pb[1]^-1 : pb in PseudoBasis(Module(lat)) ];

  gram := GramMatrix(lat, Basis(Module(lat)))^(-1);

  // The dimension.
  dim := Nrows(gram);

  a := Involution(ReflexiveSpace(lat));
  // In the orthogonal case, we want to divide by 2
  factor := (Order(a) eq 2) select 1 else 2; 
  
  // Compute the level of the lattice.
  lat`Level := (&+[ idls[i] * a(idls[i]) * gram[i,i]/factor : i in [1..dim ] ] +
		&+[ idls[i] * a(idls[j]) * gram[i,j]
		    : i,j in [1..dim] | i lt j ])^-1;
  
  // Return it.
  return lat`Level;
end intrinsic;

intrinsic Divisor(lat::ModDedLat) -> RngOrdFracIdl
{ Compute the divisor ideal of the lattice. }
  // The coefficient ideals.
  idls := [ pb[1] : pb in PseudoBasis(Module(lat)) ];

  // The rank of the lattice.
  dim := #idls;

  // This is only implemented for ternary lattices.
  require dim eq 3: "Only implemented for ternary lattices.";

  gram := GramMatrix(lat, Basis(Module(lat)));

  // Values of the Gram matrix for easy reference.
  a := gram[1,1] / 2; b := gram[2,2] / 2; c := gram[3,3] / 2;
  r := gram[2,3]; s := gram[1,3]; t := gram[1,2];
  
  // The (i,j)-cofactor ideals.
  A11 := (idls[2] * idls[3])^2 * (4*b*c - r^2);
  A12 := idls[1] * idls[2] * idls[3]^2 * (2*c*t - r*s);
  A13 := idls[1] * idls[2]^2 * idls[3] * (r*t - 2*b*s);
  A22 := (idls[1] * idls[3])^2 * (4*a*c - s^2);
  A23 := idls[1]^2 * idls[2] * idls[3] * (2*a*r - s*t);
  A33 := (idls[1] * idls[2])^2 * (4*a*b - t^2);

  // Return the divisor ideal.
  return A11 + A22 + A33 + 2*A12 + 2*A13 + 2*A23;
end intrinsic;

intrinsic Trace(p::RngOrdFracIdl, a::FldAut) -> RngOrdFracIdl
{Return the ideal generated by [g + a(g) : g in Generators(p)].}
  F := FixedField(a);
  return ideal<Integers(F) | [g + a(g) : g in Generators(p)]>;
end intrinsic;

intrinsic Norm(p::RngOrdFracIdl, a::FldAut) -> RngOrdFracIdl
{Return the ideal generated by [g * a(g) : g in Generators(p)].}
  F := FixedField(a);
  return ideal<Integers(F) | [g * a(g) : g in Generators(p)]>;
end intrinsic;

intrinsic Norm(lat::ModDedLat) -> RngOrdFracIdl
{ Compute the norm of the lattice. }
  // If the norm has already been computed, return it.
  if assigned lat`Norm then return lat`Norm; end if;

  // The coefficient ideals.
  idls := [ pb[1] : pb in PseudoBasis(Module(lat)) ];

  gram := GramMatrix(lat, Basis(Module(lat)));

  // The dimension.
  dim := Nrows(gram);

  a := Involution(ReflexiveSpace(lat));
  F := FixedField(a);
  
  // Compute the norm ideal for the lattice.
  lat`Norm := &+[ (F!gram[i,i]) * Norm(idls[i], a) : i in [1..dim] ] +
	      &+[ Trace(idls[i] * a(idls[j]) * gram[i,j], a) : i,j in [1..dim]
		  | i lt j ];
  
  // Return the norm.
  return lat`Norm;
end intrinsic;

intrinsic GramMatrix(lat::ModDedLat, vecs::SeqEnum[ModTupFldElt]) -> AlgMatElt
{.}
  // The underlying basis for lattice.
  basis := Matrix(vecs);

  // The involution of the reflexive space
  alpha := Involution(ReflexiveSpace(lat));

  F := BaseField(alpha);

  basis := ChangeRing(basis, F);

  // The Gram matrix for the underlying basis.
  gram := basis * InnerForm(ReflexiveSpace(lat)) *
    Transpose(alpha(basis));

  return gram;
end intrinsic;

intrinsic Scale(lat::ModDedLat) -> RngOrdFracIdl
{ Compute the scale of the lattice. }
  // Return the scale if it has already been computed.
  if assigned lat`Scale then return lat`Scale; end if;

  // Extract the coefficient ideals.
  idls := [ pb[1] : pb in PseudoBasis(lat) ];

  gram := GramMatrix(lat, Basis(Module(lat)));
  
  // The dimension of the vector space.
  dim := Nrows(gram);

  a := Involution(ReflexiveSpace(lat));
  
  // Compute the scale of the lattice.
  lat`Scale := &+[gram[i,j] * idls[i] * a(idls[j]) : i,j in [1..dim]];

  // Return the scale.
  return lat`Scale;
end intrinsic;

intrinsic ElementaryDivisors(lambda::ModDedLat, pi::ModDedLat)
	  -> SeqEnum[RngOrdFracIdl]
{.}
   return ElementaryDivisors(Module(lambda), Module(pi));
end intrinsic;

intrinsic Discriminant(lambda::ModDedLat, pi::ModDedLat) -> RngOrdFracIdl
{.}
  return &*ElementaryDivisors(lambda, pi);
end intrinsic;

intrinsic Discriminant(lat::ModDedLat :
		       GramFactor := 1, Half := false) -> RngOrdFracIdl
{ Compute the discriminant of the lattice. }
  // Return the discriminant if it's already been computed.
  if not assigned lat`Discriminant then 
     lat`Discriminant := Discriminant(DualLattice(lat), lat);
  end if;

  ret := lat`Discriminant;

  if GramFactor eq 2 then
     r := Rank(lat);
     ret *:= 2^r;
  end if;

  if Half then
    ret := 1/2*ret;
  end if;

  return ret;
end intrinsic;


intrinsic IntersectionLattice(lat1::ModDedLat, lat2::ModDedLat) -> ModDedLat
{ Computes the intersection lattice of the two specified lattices. }
  // Make sure both lattices belong to the same ambient reflexive space.
  require ReflexiveSpace(lat1) eq ReflexiveSpace(lat2):
		"Both lattices must belong to the same reflexive space.";

  return LatticeWithPseudobasis(
		 ReflexiveSpace(lat1),
		 PseudoMatrix(Module(lat1) meet Module(lat2)));
end intrinsic;

intrinsic Index(lat1::ModDedLat, lat2::ModDedLat) -> RngOrdFracIdl
{ Compute the index of Pi in Lambda. }
  // Ensure both lattices reside in the same ambient reflexive space.
  require ReflexiveSpace(lat1) eq ReflexiveSpace(lat2):
		"Both lattices must belong to the same reflexive space.";

  index :=  &*ElementaryDivisors(Module(lat1), Module(lat2));

  // Make sure this is an integral ideal
  assert Denominator(index) eq 1;

  return index;

  // old code - good for orthogonal case only
  
  // Compute discriminants.
  disc1 := Discriminant(lat1);
  disc2 := Discriminant(lat2);

  // The quotient of the two discriminants.
  quo := disc2 / disc1;

  // Make sure this is an integral ideal.
  assert Denominator(quo) eq 1;

  // Problem - quo is a square only in the quadratic case.
  // In the unitary case, it is of the form I * alpha(I)
  // and one cannot use only quo to determine I

  // Compute the square root.
  sq, root := IsSquare(quo);

  // Make sure the square root is valid.
  assert sq;

  return root;
end intrinsic;

intrinsic IsIsometric(lat1::ModDedLat, lat2::ModDedLat :
		      Special := false, BeCareful := false) -> BoolElt, Mtrx
{ Determines whether the two specified lattices are isometric. }
  // Verify that both lattices reside in the same reflexive space.
//  require ReflexiveSpace(lat1) eq ReflexiveSpace(lat2):
//		"Both lattices must belong to the same reflexive space.";

  // Retrieve the ZLattices for each lattice.
  L1 := ZLattice(lat1);
  L2 := ZLattice(lat2);

  // Check for isometry.
  iso, f := IsIsometric(L1, AuxForms(lat1), L2, AuxForms(lat2));

  if not iso then return false, _; end if;
	
  // f := PullUp(Matrix(f), lat1, lat2 : BeCareful := BeCareful);

  // Currently, this only works for SO, where det in -1,1
  if Special and Determinant(f) eq -1 then
      // Look at the generators of the automorphism group of the
      //  first lattice.
      gens := Generators(AutomorphismGroup(lat1));
      
      // If any of the generators have determinant -1, then we can
      //  compose f and g in such a way to produce a proper isometry.
      for g in gens do
	  if Determinant(g) eq -1 then
	      return true,
		     PullUp(Matrix(f*g), lat1, lat2 :
			    BeCareful := BeCareful);
	  end if;
      end for;

      // Same as above.
      gens := Generators(AutomorphismGroup(lat2));
      for g in gens do
	  if Determinant(g) eq -1 then
	      return true,
		     PullUp(Matrix(g*f), lat1, lat2 :
			    BeCareful := BeCareful);
	  end if;
      end for;
      
      // No generators of determinant -1 found, therefore these two
      //  lattices are not properly isometric.
      return false, _;
  end if;
  
  return iso, PullUp(Matrix(f), lat1, lat2 : BeCareful := BeCareful);
end intrinsic;

intrinsic AutomorphismGroup(lat::ModDedLat : Special := false) -> SeqEnum
{ Computes the automorphism group of the specified lattice. }
  if Special then
      vprintf AlgebraicModularForms, 2:
         "In AutomorphismGroup, with Special flag.\n";
      if assigned lat`SpecialAutomorphismGroup then
	  return lat`SpecialAutomorphismGroup;
      end if;
      vprintf AlgebraicModularForms, 2:
	"Computing the regular automorphism group.\n";
      aut := AutomorphismGroup(lat);
      // Problem - this takes too long
      // return sub<aut |[x : x in aut | Determinant(x) eq 1]>;
      // This is to get the group {+-1}
      C2, phi := UnitGroup(Integers());
      vprintf AlgebraicModularForms, 2:
	"Defining determinant.\n"; 
// det_gens := [Determinant(x) : x in Generators(aut)];
      det_gens := [Determinant(aut.i) : i in [1..NumberOfGenerators(aut)]]; 
      det := hom<aut -> C2 | [x @@ phi : x in det_gens]>;
      vprintf AlgebraicModularForms, 2:
	"Finding kernel.\n"; 
      special_aut := Kernel(det);
      vprintf AlgebraicModularForms, 2:
	"Done. Saving and returning.\n";
      // Save it for further use.
      lat`SpecialAutomorphismGroup := special_aut;
      return special_aut;
  end if;

  // Return the automorphism group if it has already been computed.
  if assigned lat`AutomorphismGroup then
      return lat`AutomorphismGroup;
  end if;
  
  // Compute the automorphism group of this lattice.
  aut := AutomorphismGroup(ZLattice(lat), AuxForms(lat));
  
  // Save it for further use.
  lat`AutomorphismGroup := aut;
  
  return lat`AutomorphismGroup;
end intrinsic;

intrinsic IsFree(L::ModDedLat) -> BoolElt
{ Determines whether the lattice is a free lattice or not. }
  // The pseudobasis for the lattice.
  psBasis := PseudoBasis(L);

  // The lattice is free if and only if the product of its coefficient
  //  ideals is principal.
  value := IsPrincipal(&*[ pb[1] : pb in psBasis ]);
  
  // Return value.
  return value;
end intrinsic;

intrinsic FreeBasis(L::ModDedLat) -> SeqEnum
{ Computes and returns a basis for a free lattice. }
  // Require the lattice to be free.
  require IsFree(L): "Lattice must be free.";

  // The reflexive space.
  V := ReflexiveSpace(L);

  // The pseudobasis for the lattice.
  psBasis := PseudoBasis(L);

  // Extract the bases and coefficient ideals.
  idls := [ pb[1] : pb in psBasis ];
  basis := [ pb[2] : pb in psBasis ];

  // Dimension of the lattice.
  dim := Dimension(L);

  for i in [1..dim-1] do
      // Determine whether the current coefficient ideal is principal.
      check, elt := IsPrincipal(idls[i]);	

      // If principal, then scale the basis with the generator.
      if check then
	  idls[i] /:= idls[i];
	  basis[i] *:= elt;
	  continue;
      end if;
      
      // Convert the coefficient ideals into integral ideals.
      aa := Denominator(idls[i]); A := aa * idls[i];
      bb := Denominator(idls[i+1]); B := bb * idls[i+1];
      assert IsIntegral(A) and IsIntegral(B);
      
      // Generators of idls[i].
      gs := Generators(A);
      
      // Find elements according to Cohen's Proposition 1.3.12.
      repeat
	  repeat x := Random(5); y := Random(5);
	  until x ne 0 and y ne 0;
	  a := x * gs[1] + y * gs[2];
      until IsIntegral(a * idls[i]^-1) and
	    Factorization(a*A^-1 + B) eq [];
      
      // Construct a matrix so that we can apply HNF.
      C := Matrix([ Eltseq(x) : x in Basis(a*A^-1) cat Basis(B) ]);
      C := ChangeRing(C, Integers());
      
      // Perform an HNF.
      H, U := HermiteForm(C);
      
      // Verify that the top half of H is the identity matrix.
      assert Submatrix(H,[1..#gs],[1..#gs]) eq 1;
      
      // Find elements e and f following Cohen Algorithm 1.3.2.
      X := Submatrix(U, [1..1], [1..#gs]);
      AA := Matrix([ Eltseq(x) : x in Basis(a*A^-1) ]);
      AA := ChangeRing(AA, Integers());
      e := Order(A) ! Eltseq(X * AA);
      f := 1 - e;

      // Verify that the elements we chose are in the correct ideals.
      assert e in a * A^-1 and f in B;

      // Coefficients according to Cohen's Proposition 1.3.12.
      b := f / bb;
      c := (Order(B)!(-1)) * bb;
      d := e / a;
      
      // Verify that these elements belong the correct ideals.
      assert a*d - b*c eq 1;
      assert a in idls[i];
      assert b in idls[i+1];
      assert c in idls[i+1]^-1;
      assert d in idls[i]^-1;

      // The new bases and coefficient ideals.
      vec1 := a * basis[i] + b * basis[i+1];
      vec2 := c * basis[i] + d * basis[i+1];
      basis[i] := vec1;
      basis[i+1] := vec2;
      idls[i+1] *:= idls[i];
      idls[i] /:= idls[i];
  end for;
  
  // Confirm that the last ideal is principal.
  check, elt := IsPrincipal(idls[#idls]);
  assert check;

  // Update the last basis element.
  basis[#idls] *:= elt;
  
  assert LatticeWithBasis(V, Matrix(basis)) eq L;

  return basis;
end intrinsic;

intrinsic PullUp(g::AlgMatElt, Lambda::ModDedLat, Pi::ModDedLat :
		 BeCareful := false) -> AlgMatElt
  {Takes an isometry g : Pi -> Lambda and reexpresses it as an L-linear map gV : V -> V.}

  LambdaZZ := ZLattice(Lambda);
  LambdaZZAuxForms := AuxForms(Lambda);
  PiZZ := ZLattice(Pi);
  PiZZAuxForms := AuxForms(Pi);   
  BL := Matrix([&cat[Eltseq(z) : z in Eltseq(y)] : y in Rows(LambdaZZ`basisZ)]);
  BP := Matrix([&cat[Eltseq(z) : z in Eltseq(y)] : y in Rows(PiZZ`basisZ)]);
  m := Dimension(Lambda);
  V := VectorSpace(AmbientSpace(Lambda));
  L := BaseField(V);
  d := Degree(L);
  rows := [];
  for i in [1..m] do
    v := Vector(&cat[Eltseq(x) : x in Eltseq(V.i)]);
    rowQ := Eltseq(v*BP^-1*(Parent(BL)!g)*BL);
    rowL := Vector([L!rowQ[j*d+1..(j+1)*d] : j in [0..m-1]]); 
    Append(~rows,rowL);
  end for;
  
  ans := Matrix(rows);
  
  if BeCareful then
    alpha := Involution(ReflexiveSpace(Lambda));
    print "gV maps Pi into Lambda?", &and[ChangeRing(x,L)*ans in Module(Lambda) :
					x in PiZZ`basisR];
    print "gV respects the inner product?", InnerProductMatrix(V) eq ans*InnerProductMatrix(V)*alpha(Transpose(ans));
  end if;
  
  return ans;
end intrinsic;

// functions for a-maximal lattices

function GramMatrixOfBasis(L)
  P:= PseudoBasis(Module(L));
  U:= Universe(P);
  C:= [ U[1] | p[1]: p in P ];
  B:= [ U[2] | p[2]: p in P ] ;
  return GramMatrix( L, B ), C, B;
end function;

intrinsic DualLattice(L::ModDedLat) -> ModDedLat
{return the dual of the lattice L - lattice L^# such that <L,L^#> = ZZ_F}
  V := ReflexiveSpace(L);
  G, C, B:= GramMatrixOfBasis(L);
  if #B eq 0 then return L; end if;	// L==0
  GI:= G^-1;
//  BB:= [ &+[ GI[i,j] * B[j] : j in [1..#B] ] : i in [1..#B] ];
  BB:= GI * Matrix(B);
  a:= Involution(V);
  return LatticeWithBasis(V, BB, [a(c)^(-1) : c in C]);
end intrinsic;

intrinsic '*'(a::RngOrdFracIdl, L::ModDedLat) -> ModDedLat
{.}
  P:= PseudoBasis(Module(L));
  U:= Universe(P);
  C:= [ U[1] | p[1]: p in P ];
  B:= [ U[2] | p[2]: p in P ];
  V := ReflexiveSpace(L);
  return LatticeWithBasis(V, Matrix(B), [a*c : c in C]);
end intrinsic;

intrinsic 'subset'(lambda::ModDedLat, pi::ModDedLat) -> BoolElt
{.}
   return Module(lambda) subset Module(pi);
end intrinsic;

intrinsic DualLattice(L::ModDedLat, a::RngOrdFracIdl) -> ModDedLat
{.}
  return a * DualLattice(L);
end intrinsic;

intrinsic Rank(L::ModDedLat) -> RngIntElt
{The rank or dimension of the lattice L}
  return Dimension(L`Module);
end intrinsic;

intrinsic IsZero(L::ModDedLat) -> BoolElt
{Tests if the lattice L is zero}
  return Rank(L) eq 0;
end intrinsic;

intrinsic Degree(L::ModDedLat) -> RngIntElt
{The degree of the lattice L}
  return Degree(L`Module);
end intrinsic;

intrinsic IsFull(L::ModDedLat) -> BoolElt
{Returns true if the lattice is of full rank}
  return Dimension(L) eq Degree(L);
end intrinsic;

intrinsic InnerProductMatrix(L::ModDedLat) -> Mtrx
{Returns the inner product matrix of the lattice L}
  return InnerForm(ReflexiveSpace(L));
end intrinsic;

// check if this still works for hermitian forms
function MyDiagonal(L, Ambient)
  if Ambient and not IsFull(L) then
    return Diagonal(OrthogonalizeGram(InnerProductMatrix(L)));
  else
      F:= IsFull(L) select InnerProductMatrix(L) else
	  GramMatrix(L, Basis(Module(L)));
      diagonal:= Diagonal(OrthogonalizeGram(F));
  end if;
  return diagonal;
end function;

// The even HilbertSymbol code

// We first start with our implementation of Alg. 6.2 -- 6.5 of
// John Voight, Characterizing quaternion rings over an arbitrary base, J. Reine Angew. Math. 657 (2011), 113-134.
function SolveCongruence(a,b,p)
  //assert Valuation(a,p) eq 0;
  //assert Valuation(b,p) eq 1;
  pi:= PrimitiveElement(p);
  k, h:= ResidueClassField(p);
  y:= 1/(SquareRoot(a @ h) @@ h); z:= 0;
  ee:= 2*RamificationIndex(p);
  told:= -1;
  while true do
    N:= 1 - a*y^2 - b*z^2;
    t:= Valuation(N, p); assert t gt told; told:= t;
    if t ge ee then return y,z; end if;
    w:= pi^(t div 2);
    if IsEven(t) then
      y +:= SquareRoot((N/(a*w^2)) @ h) @@ h * w;
    else
      z +:= SquareRoot((N/(b*w^2)) @ h) @@ h * w;
    end if;
  end while;
end function;

// Decide if a*x^2=1 mod p^e
// This is a variant of O'Meara ???. The code assumes that 0 <= e <= 2*RamIdx(p)
function CanLiftSquare(a,p,e)
  assert Valuation(a,p) eq 0;
  if Valuation(a-1, p) ge e then return true, Order(p) ! 1, e; end if;
  aold:= a;
  pi:= PrimitiveElement(p);
  k, h:= ResidueClassField(p);
  x:= SquareRoot( (a @ h)^-1 ) @@ h;
  a *:= x^2;
  t:= Valuation(a-1, p);
  while t lt e and IsEven(t) do
    s:= SquareRoot(h((a-1)/pi^t));
    s:= 1+(s@@h)*pi^(t div 2);
    a /:= s^2;
    x := x/s;
    tt:= Valuation(a-1, p);
    assert tt gt t;
    t:= tt;
  end while;
  t:= Min(t,e);
  assert Valuation(aold*x^2-1, p) ge t;
  return t eq e, x, t;
end function;

function SolveCongruence2(a,b,p)
  if Valuation(b, p) eq 1 then 
    y,z:= SolveCongruence(a,b,p);
    return y,z,0;
  end if;
  
  e:= RamificationIndex(p);
  pi:= PrimitiveElement(p);
  oka, a0, t:= CanLiftSquare(a, p, e);
  if oka then
    okb, b0, t:= CanLiftSquare(b, p, e);
    if okb then return a0, b0, a0*b0; end if;
    bt:= (b-(1/b0)^2) /pi^t;
    y, z:= SolveCongruence(b, -pi*bt/a, p);
    w:= pi^(t div 2);
    return w*b0/z, b0, y*w*b0/z;
  else
    at:= (a-(1/a0)^2) /pi^t;
    y, z:= SolveCongruence(a, -pi*at/b, p);
    w:= pi^(t div 2);
    return a0, w*a0/z, y*w*a0/z;
  end if;
end function;

normalize:= function(a, p)
  vala:= Valuation(a, p);
  n:= vala div 2;
  if n ne 0 then a /:= PrimitiveElement(p)^(2*n); vala -:= 2*n; end if;
  assert Valuation(a, p) eq vala and vala in {0,1};
  return a, vala;
end function;

intrinsic MyEvenHilbertSymbol(a::FldElt,b::FldElt,p::RngOrdIdl) -> RngIntElt
{}
  a, vala:= normalize(a, p);
  b, valb:= normalize(b, p);
  if vala eq 1 then
    if valb eq 1 then
      a:= (-a*b) / PrimitiveElement(p)^2;
    else
      x:= a; a:= b; b:= x;
    end if;
  end if;

  // lift solution to precision 2e
  y,z,w:= SolveCongruence2(a,b,p);
  nrm:= 1-a*y^2-b*z^2+a*b*w^2;
  assert Valuation(nrm, p) ge 2*RamificationIndex(p);
  tmp:= (b*z)^2*a + (a*y)^2*b;

  if tmp eq 0 or IsEven(Valuation(tmp, p)) then 
    res:= 1;
  else
    k,h:= ResidueClassField(p);
    res:= not IsIrreducible(Polynomial([k| (nrm/4)@h,-1,1])) select 1 else -1; 
  end if;
  //assert res eq HilbertSymbol(a,b,p);
  return res;
end intrinsic;

intrinsic MyHilbertSymbol(a::FldAlgElt, b::FldAlgElt, p::RngOrdIdl) -> RngIntElt
{The Hilbert symbol of a and b at p}
  if IsOne(a) or IsOne(b) then return 1; end if;
  require not IsZero(a) and not IsZero(b): "The elements must be non-zero";
  require IsPrime(p): "The ideal must be prime";
  return Minimum(p) ne 2 select HilbertSymbol(a,b,p) else MyEvenHilbertSymbol(a,b,p);
end intrinsic;

// Isometry testing over the field of fractions
HS:= func<a,b,p | Type(p) eq RngIntElt select HilbertSymbol(a/1,b/1,p) else MyHilbertSymbol(a/1,b/1,p) >;
Hasse:= func< D, p | &*[ Integers() | HS(D[i], &*D[ [i+1..n] ], p) : i in [1..n-1] ] where n:= #D >;

intrinsic WittInvariant(L::ModDedLat, p::RngOrdIdl :
			AmbientSpace:= false) -> RngIntElt
{The Witt invariant of L at p}
  R:= Order(p);
  require R cmpeq BaseRing(L) and IsPrime(p):
    "The second argument must be a prime ideal of the base ring of the lattice";
  h:= Hasse(MyDiagonal(L, AmbientSpace), p);
  Det:= Determinant(GramMatrixOfBasis(L));
  K:= NumberField(R);
  c:= K ! case < Degree(L) mod 8 |
	       3: -Det, 4: -Det, 5: -1, 6: -1, 7: Det, 0: Det, default : 1 >;
  return h * HS(K ! -1, c, p);
end intrinsic;

function GuessMaxDet(L, p)
  m:= Rank(L); n:= m div 2;
  d:= Determinant(GramMatrixOfBasis(L));
  e:= 2*Valuation(Order(p) ! 2, p);
  if IsOdd(m) then
    v:= Valuation(d, p) mod 2;
    v:= WittInvariant(L, p) eq 1 select v-e*n else 2-v-e*n;
  else
    if IsOdd( (m*(m-1)) div 2 ) then d := -d; end if;
    qd:= QuadraticDefect(d, p);
    if Type(qd) eq Infty then
      v:= WittInvariant(L, p) eq 1 select -e*n else 2-e*n;
    else		// Wrong? Fix scaling \alpha
      vd:= Valuation(d, p);
      v:= vd - 2*(qd div 2) + e*(1-n);
      //if IsEven(vd) and qd eq vd+e and WittInvariant(L,p) eq -1 then v:= v+2; end if;
/*K:= NumberField(BaseRing(L));
F:= ext< K | Polynomial([-d,0,1]) >;
ram:= IsRamified(p, Integers(F));
assert  (IsEven(vd) and qd eq vd+e) eq not ram;*/
      if IsEven(vd) and qd eq vd+e and WittInvariant(L,p) eq -1 then v:= -e*n+2; end if;
    end if;
  end if;
  return v;
end function;

intrinsic Lattice(V::RfxSpace, L::ModDed) -> ModDedLat
{.}
  pb := PseudoBasis(L);
  I := [ p[1] : p in pb];
  B := [ p[2] : p in pb];
  return LatticeWithBasis(V, Matrix(B), I);
end intrinsic;

intrinsic LocalBasis(M::ModDed, p::RngOrdIdl : Type:= "") -> []
{A basis of a free module that coincides with M at the prime ideal p}
  require Order(p) cmpeq BaseRing(M) : "Incompatible arguments";
  require Type in {"", "Submodule", "Supermodule"} : "Type must be \"Submodule\" or \"Supermodule\" when specified";
  if Type eq "" then
    pi:= UniformizingElement(p);
  end if;
  B:= [ EmbeddingSpace(M) | ];
//  B:= [ VectorSpace(FieldOfFractions(BaseRing(M)), Degree(M)) | ];
  for pp in PseudoBasis(M) do
    g:= Generators(pp[1]);
    if #g eq 1 then x:= g[1];
    elif Type eq "" then x:= pi^Valuation(pp[1], p);
    else
      Fact:= Factorization(pp[1]);
      Fact:= Type eq "Submodule" select [ f: f in Fact | f[1] eq p or f[2] gt 0 ]
                                   else [ f: f in Fact | f[1] eq p or f[2] lt 0 ];
      if forall{ f: f in Fact | f[1] ne p } then Append(~Fact, <p, 0>); end if;
      x:= WeakApproximation([ f[1] : f in Fact ], [ f[2] : f in Fact ]);
    end if;
    assert Valuation(x, p) eq Valuation(pp[1], p);
    Append(~B, pp[2]*x);
  end for;
  return B;
end intrinsic;

intrinsic IsIntegral(L::ModDedLat, p::RngOrdIdl) -> BoolElt
{.}
  val2:= Valuation(BaseRing(L)!2, p);
  G, C := GramMatrixOfBasis(L);
  D := Diagonal(G);
  alpha := Involution(ReflexiveSpace(L));
  min_diag := Minimum([Valuation(C[i],p) + Valuation(alpha(C[i]),p) +
		       Valuation(D[i],p) : i in [1..#C]]);
  min_val := Minimum([Valuation(C[i],p) + Valuation(alpha(C[j]),p)
		      + Valuation(G[i,j],p) : i, j in [1..#C]]);
  return (min_val ge -val2) and (min_diag ge 0);
end intrinsic;

intrinsic IsIntegral(L::ModDedLat) -> BoolElt
{.}
  return &and[IsIntegral(L,p) : p in BadPrimes(L)];
end intrinsic;

intrinsic IsMaximalIntegral(L::ModDedLat, p::RngOrdIdl) -> BoolElt, ModDedLat
{Checks whether L is p-maximal integral. If not, a minimal integral over-lattice at p is returned}
  require Order(p) cmpeq BaseRing(L) and IsPrime(p): 
    "The second argument must be a prime ideal of the base ring of the lattice";
  require not IsZero(L): "The lattice must be non-zero";
  a := Involution(ReflexiveSpace(L));
  // In this case it is not integral
  if IsIdentity(a) then
      norm := ideal<Order(p)| Norm(L) >;
      if Valuation(norm, p) lt 0 then return false, _; end if;
      if GuessMaxDet(L, p) eq Valuation(Discriminant(L), p)
	  then return true, _;
      end if;
  end if;
 
  k, h:= ResidueClassField(p);
  BM:= Matrix(LocalBasis(Module(L), p: Type:= "Submodule"));
  
  //G:= factor*GramMatrix(L, Rows(BM));
  // G:= 2*GramMatrix(L, Rows(BM));
  G := GramMatrix(L, Rows(BM));

  if IsIdentity(a) then
      basis := [BaseRing(L)!1];
  else
      basis := Basis(BaseRing(L));
  end if;
  // we want Trace(<v.w>) = 0 and Trace(<alpha*v,w>) = 0
  // for all w, giving the following equations:
  // actually a basis over F should suffice.
  // How do we pull that off?
  Gs := [alpha*G + a(alpha*G) : alpha in basis];
  row_seqs := [[h(basis[i]*x) : x in Eltseq(Gs[i])] : i in [1..#basis]];
  mat := Matrix(#basis * Nrows(BM), &cat row_seqs);
  V:= KernelMatrix(mat);
  if Nrows(V) eq 0 then return true, _; end if;
  
  FF:= BaseRing(BM);
  val2:= Valuation(BaseRing(L)!2, p);
  PP:= ProjectiveLineProcess(k, Nrows(V));
  x:= Next(PP);
  while not IsZero(x) do
    e:= Eltseq(x * V) @@ h;
    v:= Vector(FF, e);
    valv:= Valuation( ((v*G) * a(Matrix(FF,1,e)))[1], p );
    // assert valv ge 1;
    assert valv ge 0;
    // TODO: Better code depending on whether -1 is a square or not and then take (1,p) or (p,p)
    // if valv ge val2+2 then
    if valv ge 2 then
	pMod := Module( [WeakApproximation([p], [-1]) *v*BM ] );
	lat := Lattice(ReflexiveSpace(L), Module(L) + pMod);
	assert IsIntegral(lat);
	return false, lat; 
    end if;
    x:= Next(PP);
  end while;
  if IsIdentity(a) then
      assert GuessMaxDet(L, p) eq Valuation(Discriminant(L), p);
  end if;
  return true, _;
end intrinsic;

intrinsic BadPrimes(L::ModDedLat) -> []
{The list of prime ideals at which L is not unimodular or which are even}
  return { f[1] : f in Factorization(Scale(L)) } join { f[1] : f in Factorization(2*Discriminant(L)) };
end intrinsic;  

intrinsic IsMaximalIntegral(L::ModDedLat) -> BoolElt, ModDedLat
{Checks whether L is maximal integral. If not, a minimal integral over-lattice is returned}
  for p in BadPrimes(L) do
    ok, LL:= IsMaximalIntegral(L, p);
    if not ok then return false, LL; end if;
  end for;
  return true, _;
end intrinsic;

intrinsic MaximalIntegralLattice(L::ModDedLat, p::RngOrdIdl) -> ModDedLat
{A p-maximal integral lattice over L}
  require Order(p) eq BaseRing(L) and IsPrime(p): "The second argument must be a prime ideal of the base ring of L";
  norm := ideal<Order(p)| Norm(L) >;						
  require not IsZero(L) and Valuation(norm, p) ge 0 : "The norm of the lattice must be locally integral";

  ok, LL:= IsMaximalIntegral(L, p);
  while not ok do 
    L:= LL;    
    ok, LL:= IsMaximalIntegral(L, p);
  end while;
  return L;
end intrinsic;

intrinsic MaximalIntegralLattice(L::ModDedLat) -> ModDedLat
{A maximal integral lattice containing L}
  require not IsZero(L) and IsIntegral(Norm(L)) :
    "The lattice must be integral and non-zero";

  for p in BadPrimes(L) do
    ok, LL:= IsMaximalIntegral(L, p);
    while not ok do 
      L:= LL;    
      ok, LL:= IsMaximalIntegral(L, p);
    end while;
  end for;
  return L;
end intrinsic;

intrinsic MaximalIntegralLattice(V::RfxSpace) -> ModDedLat
{A lattice which is maximal integral in the reflexive space V}

  R:= BaseRing(V); T:= Type(R); Q := InnerForm(V); a:= Involution(V);
/*
  if ISA(T, RngOrd) then
    F:= FieldOfFractions(R);
    Q:= Matrix(F, Q);
  elif ISA(T, FldNum) then
    R:= Integers(R);
    F:= FieldOfFractions(R);
    Q:= Matrix(F, Q);
  else
    require ISA(T, FldOrd) : "The matrix must be over (the field of fractions of) an order";
    F:= R;
    R:= Integers(R);
  end if;
*/
  F := FixedField(a);
  R := Integers(F);
  n:= Nrows(Q);
  require Rank(Q) eq n : "The form must be non-degenerate";

  // We start with some integral lattice.
  L:= StandardLattice(V);
  N:= Norm(L);
  if N ne 1*R then
    FN:= Factorization(N);
    d:= &*[ f[1]^(f[2] div 2) : f in Factorization(N) ];
    L:= d^-1*L;
    N:= Norm(L);
    assert IsIntegral(N);
  end if;

  return MaximalIntegralLattice(L);
end intrinsic;

intrinsic QuadraticFormInvariants(M::AlgMatElt[FldAlg]: Minimize:= true) -> FldAlgElt, SetEnum[RngOrdIdl], SeqEnum[RngIntElt]
{The invariants describing the quadratic form M}
  require IsSymmetric(M) and Rank(M) eq Ncols(M): "The form must be symmetric and regular";
  D:= Diagonal(OrthogonalizeGram(M));
  K:= BaseRing(M);
  R:= Integers(K);
  P:= { d[1] : d in Decomposition(R, 2) };
  U:= Universe(P);
  for d in D do
    P join:= { f[1] : f in Factorization(d*R) | IsOdd(f[2]) };
  end for;
  F:= Minimize select {U | p : p in P | Hasse(D, p) eq -1 } else { <p, Hasse(D, p) > : p in P };
  I:= [ #[ d: d in D | Evaluate(d, f) le 0 ] : f in RealPlaces(K) ];
  return &* D, F, I;
end intrinsic;

intrinsic JordanDecomposition(L::ModDedLat, p::RngOrdIdl) -> []
{A Jordan decomposition of the completion of L at p}
  require BaseRing(L) cmpeq Order(p): "The arguments are incompatible";
  require IsPrime(p) : "The second argument must be prime";

  even:= Minimum(p) eq 2;
  if even then pi:= PrimitiveElement(p); end if;
//  B:= LocalBasis(M, p: Type:= "Submodule");
  F:= InnerProductMatrix(L);
  B:= LocalBasis(Module(L), p);
  n:= #B;
  k:= 1;

  oldval:= Infinity();
  Blocks:= []; Exponents:= [];

  S:= Matrix(B);
  while k le n do
    G:= S*F*Transpose(S);

    // find an element <i, j> with minimal p-valuation.
    // Take it from the diagonal, if possible, and from the lowest-possible row number.
    X:= [ Valuation(G[i,i], p): i in [k..n] ];
    m, ii:= Minimum( X ); ii +:= k-1;
    pair:= <ii, ii>;

    for i in [k..n], j in [i+1..n] do
      tmp:= Valuation(G[i,j], p);
      if tmp lt m then m:= tmp; pair:= <i,j>; end if;
    end for;
    if m ne oldval then Append(~Blocks, k); oldval:= m; Append(~Exponents, m); end if;

    if even and pair[1] ne pair[2] then
//      printf "2 has no inverse, <%o,%o>\n", pair[1], pair[2];
//      printf "S=%o\n", print_matrix(ChangeRing(S, Integers()));

      SwapRows(~S, pair[1],   k); // swap f_1 and e_i
      SwapRows(~S, pair[2], k+1); // swap f_2 and e_j
      T12:= (S[k] * F * Matrix(1, Eltseq(S[k+1])))[1];
      S[k] *:= pi^Valuation(T12, p)/T12;
      T := func<i,j|(S[i] * F * Matrix(1, Eltseq(S[j])))[1]>;
      T11 := T(k,k); T22 := T(k+1, k+1); T12:= T(k, k+1);

//      printf "d=%o*%o - %o\n", T(1,1),T(2,2), T(1,2)^2;
      d := T11*T22 - T12^2;
      for l in [k+2..n] do
        tl := T12*T(k+1,l)-T22*T(k  ,l); // t_k from step 4
        ul := T12*T(k  ,l)-T11*T(k+1,l); // u_k from step 4
        S[l] +:= (tl/d)*S[k] + (ul/d)*S[k+1];
      end for;
      k +:= 2;
    else
//      printf "pair is %o\n", pair;
      if pair[1] eq pair[2] then
//        printf "swapping %o and %o\n", pair[1], k;
        SwapRows(~S, pair[1], k);
      else
//        printf "adding %o to $o\n", pair[2], pair[1];
        S[pair[1]] +:= S[pair[2]];
        SwapRows(~S, pair[1], k);
      end if;
      nrm:= (S[k] * F * Matrix(1, Eltseq(S[k])))[1];
//      printf "nrm = %o\n", nrm;
      X:= S[k] * F * Transpose(S); // T(e_k, f_i), 1<=i<=n
//      printf "renorming %o..%o\n", k+1, n;
      for l in [k+1..n] do S[l] -:= X[l]/nrm * S[k]; end for;
      k+:= 1;
    end if;
  end while;

  Append(~Blocks, n+1);
  Matrices:= [* RowSubmatrix(S, Blocks[i], Blocks[i+1] - Blocks[i]) : i in [1..#Blocks-1] *];

  return Matrices, [* m*F*Transpose(m): m in Matrices *], Exponents;
end intrinsic;  

// functions for p-adic completion and p-adic lattices

declare type RngPadIdl;
declare attributes RngPadIdl :
		   // the ring
		   R,
		   generator;

intrinsic Ideal(R::RngPad, t::.) -> RngPadIdl
{.}
  if Type(t) ne SeqEnum then t := [t]; end if;
  pi := UniformizingElement(R);
  val := Minimum([Valuation(R!x) : x in t]);
  I := New(RngPadIdl);
  I`R := R;
  I`generator := pi^val;
  return I;
end intrinsic;

intrinsic Generators(I::RngPadIdl) -> SeqEnum[RngPadElt]
{.}
  return [I`generator];
end intrinsic;

intrinsic Print(I::RngPadIdl)
{.}
  printf "Ideal of %o generated by %o", I`R, I`generator;
end intrinsic;

intrinsic '#'(I::RngPadIdl) -> RngIntElt
{.}
  k := ResidueClassField(I`R);
  v := Valuation(I`generator);
  return (#(I`R) / (#k)^v);
end intrinsic;  

declare type ModPad[ModTupFldElt];
declare attributes ModPad :
		   // the base ring
		   R,
	// the field of fractions
	F,
	// basis
	basis;

intrinsic Module(R::RngPad, n::RngIntElt) -> ModPad
{Create the free module R^n where R is a p-adic ring.}
  M := New(ModPad);
  M`R := R;
  M`F := FieldOfFractions(R);
  M`basis := Rows(IdentityMatrix(M`F, n));
  
  return M;
end intrinsic;

intrinsic pAdicModule(S::SeqEnum[ModTupFldElt]) -> ModPad
{Create a module from the sequence of ModElts with entries in the p-adic ring or its field of fractions. The elements of the resulting module will be the linear combinations of the ModElts.}
  M := New(ModPad);
  M`F := FieldOfFractions(BaseRing(Universe(S)));
  M`R := Integers(M`F);
  M`basis := S;

  return M;
end intrinsic;

intrinsic Print(L::ModPad)
{.}
  printf "Module over %o generated by: ", L`R;
  for b in L`basis do
    printf "\n%o", b;
  end for;
end intrinsic;

intrinsic '.'(L::ModPad, n::RngIntElt) -> ModTupFldElt
{.}	     
  return L`basis[n];
end intrinsic;

intrinsic 'in'(v::ModTupFldElt, L::ModPad) -> BoolElt
{.}
  B := Matrix(L`basis);
  coeffs := v * B^(-1);
  return &and [c in L`R : c in Eltseq(coeffs)];
end intrinsic;

intrinsic ChangeRing(L::ModPad, R::RngPad) -> ModPad
{.}
  F := FieldOfFractions(R);
  return pAdicModule([ChangeRing(b, F) : b in L`basis]);
end intrinsic;

intrinsic DirectSum(Ls::SeqEnum[ModPad]) -> ModPad
{.}
  return pAdicModule(Rows(DirectSum([Matrix(L`basis) : L in Ls])));
end intrinsic;

intrinsic 'subset'(L1::ModPad, L2::ModPad) -> BoolElt
{.}
  return &and [b in L2 : b in L1`basis];
end intrinsic;

intrinsic 'eq'(L1::ModPad, L2::ModPad) -> BoolElt
{.}
  return (L1 subset L2) and (L2 subset L1);
end intrinsic;

intrinsic Complete(L::ModDed, p::RngOrdIdl) -> ModPad
{Compute the completion of the lattice L at the prime p}
//    if Type(L) eq ModDedLat then L := Module(L); end if;
    psb := PseudoBasis(L);
    idls := [x[1] : x in psb];
    basis := [x[2] : x in psb];
    R := FieldOfFractions(BaseRing(L));
    R_p, comp_p := Completion(R,p);
    pi := UniformizingElement(R_p);
    val_idls_p := [ Minimum([Valuation(comp_p(g)) :
			     g in Generators(I)]) : I in idls];
    basis_p := [Vector([comp_p(x) : x in Eltseq(vec)]) :
		vec in basis];
    basis_p := [pi^(val_idls_p[i]) * basis_p[i] :
		i in [1..#basis_p]];
    return pAdicModule(basis_p);
end intrinsic;

intrinsic Complete(L::ModDedLat, p::RngOrdIdl) -> ModPad
{.}
  return Complete(Module(L),p);	  
end intrinsic;

function pAdicLatticeAtSplitPrime(L,p)
    R := Integers(BaseRing(L));
    Ps := [fac[1] : fac in Factorization(ideal<R|p>)];
    L_p := [Complete(L, P) : P in Ps];
    ZZ_p := pAdicRing(p);
    L_p_pAdic := [ChangeRing(Lambda, ZZ_p) : Lambda in L_p];
    return DirectSum(L_p_pAdic);
end function;

function get_hecke_representatives(p)
    reps := [ DiagonalMatrix([p,1,1]) ];
    reps cat:= [ Matrix([[1,r,0],[0,p,0],[0,0,1]]) : r in [0..p-1]];
    reps cat:= [ Matrix([[1,0,r],[0,1,s],[0,0,p]]) : r,s in [0..p-1]];
    // The transposition is to get left cosets: KpK = U p_j K
    ret := [Transpose(r) : r in reps];
    // Checking they are indeed distinct representatives
    QQ := Rationals();
    ZZ := Integers();
    reps := [MatrixAlgebra(QQ,3)!x : x in ret];
    num := &+[r^(-1)*s in MatrixAlgebra(ZZ,3) select 1 else 0 :
	      r,s in reps];
    assert num eq #reps;
    return ret;
end function;
/*
function foo()
    QQ_2 := pAdicField(2);
    K := QuadraticField(-7);
    innerForm := IdentityMatrix(K,3);
    M := UnitaryModularForms(innerForm);
    reps := Representatives(Genus(M));
    // This came from looking at the isotropic subspace,
    // and the elementary divisors in split form - generalize later
    x := Matrix([[1,1,1],[1,1,0],[0,1,1]]);
    // the image of omega in QQ_2 (alpha is the valuation 1 element)
    alpha := (1-SquareRoot(QQ_2!(-7)))/2;
    alphabar := 1-alpha;
    mat := Transpose(x) * DiagonalMatrix([alpha/alphabar,1,1]);
    x_hat := Transpose(mat);
    // verifying that x_hat * (Lambda_0)_2 = Lambda_2
    tt := DirectSum([x_hat, Transpose(x_hat)^(-1)]);
    assert pAdicModule(Rows(tt)) eq pAdicLatticeAtSplitPrime(reps[2],2);
    return x_hat;
end function;
*/	     

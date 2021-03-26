freeze;

/****-*-magma-**************************************************************
                                                                            
                    Algebraic Modular Forms in Magma                          
                            Eran Assaf                                 
                                                                            
   FILE: genus.m (class for all genus related data and computations)

   04/24/20: Modified default value of parameter BeCareful to false. 

   04/01/20: Removed call to ModFrmAlgInit from genus - 
             no need to construct the space to compute the genus.
             Added direct call to computeGenusRepsCN1

   03/10/20: started from the orthogonal modular forms structure
 
 ***************************************************************************/

// imports

import "../neighbors/genus-CN1.m" : computeGenusRepsCN1;
import "../neighbors/inv-CN1.m" : Invariant;

///////////////////////////////////////////////////////////////////
//                                                               //
//    GenusSym: The genus symbol object.                         //
//                                                               //
///////////////////////////////////////////////////////////////////


declare type GenusSym;
declare attributes GenusSym:
	// The lattice for which this genus symbol was initialized.
	Representative,

	// Representatives for the classes in this genus.
	Representatives,

	// A partition of the genus representatives.
	RepresentativesAssoc,

	// An ordered list of theta series for the genus representatives
	ThetaSeries;

// printing

intrinsic Print(gen::GenusSym) {}
	printf "Genus symbol of size %o.", #gen`Representatives;
end intrinsic;

// access

intrinsic GenusReps(M::ModFrmAlg
	: BeCareful := false, Force := false, Orbits := false) -> SeqEnum
{ Computes the genus representatives of the inner form associated to the
	   space of algebraic modular forms provided. }
// This was here before - but we don't need to initialize the space for the genus representatives
// That's overworking.
/*
	// Initialize the space of algebraic modular forms so we can query the
	//  genus representatives.
	ModFrmAlgInit(M
		: BeCareful := BeCareful, Force := Force, Orbits := Orbits);
*/
        computeGenusRepsCN1(M : BeCareful := BeCareful, Force := Force);

	return M`genus`Representatives;
end intrinsic;

intrinsic Representative(G::GenusSym) -> .
{ Return the lattice used to construct this genus symbol. }
	return G`Representative;
end intrinsic;

intrinsic Representatives(G::GenusSym) -> SeqEnum
{ Return all lattices in the genus. }
	return G`Representatives;
end intrinsic;

// constructor from external data
intrinsic SetGenus(~M::ModFrmAlg, reps::SeqEnum[Lat] : GramFactor := 2)
{Set the Genus of M to a list of lattices.}
  M`genus := New(GenusSym);
  M`genus`Representative := Module(M);

  V_orig := ReflexiveSpace(Module(M));
  F := BaseRing(V_orig);
  // This might not work, as so far we have assumed all lattices to have
  // the same inner product matrix, and different bases
  // lats := [LatticeFromLat(rep : GramFactor := GramFactor) : rep in reps];
  lats := [];

  for rep in reps do
    lat := LatticeFromLat(rep : GramFactor := GramFactor);
    V := ReflexiveSpace(lat);
    V_F := AmbientReflexiveSpace(ChangeRing(InnerForm(V),F));
    pb := PseudoBasis(lat);
    idls := [Integers(F)!!p[1] : p in pb];
    basis := ChangeRing(Matrix([p[2] : p in pb]), F);
    lat := LatticeWithBasis(V_F, basis, idls);
    Append(~lats, lat);
  end for;

  M`genus`Representatives := lats;

  invs := AssociativeArray();
  for i in [1..#lats] do
    // Compute the invariant associated to this genus rep.
    inv := Invariant(lats[i]);

    // Assign an empty list to the invariant hash if it hasn't been
    //  assigned yet.
    if not IsDefined(invs, inv) then invs[inv] := []; end if;

    // Add to list.
    Append(~invs[inv], < lats[i], i >);
  end for;
  M`genus`RepresentativesAssoc := invs;
end intrinsic;

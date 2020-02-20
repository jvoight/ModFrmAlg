// Implementation file for the space of algebraic modular forms.

import "../orthogonal/QQ/genus-QQ.m" : computeGenusRepsQQ;
import "../orthogonal/CN1/genus-CN1.m" : computeGenusRepsCN1;

intrinsic Print(M::ModFrmAlg) {}
	K := BaseRing(InnerForm(M));
	printf "Space of algebraic modular forms over %o.\n", M`G;
	printf "Inner form:\n%o", InnerForm(M);
end intrinsic;

intrinsic IsogenyType(M::ModFrmAlg) -> MonStgElt
{ Returns the isogeny type of this space. }
	return M`isogenyType;
end intrinsic;

intrinsic IsSpecialOrthogonal(M::ModFrmAlg) -> BoolElt
{ Determines whether this space is of special orthogonal type. }
	return IsogenyType(M) eq "SO";
end intrinsic;

intrinsic IsOrthogonal(M::ModFrmAlg) -> BoolElt
{ Determines whether this space is of orthogonal type. }
	return IsogenyType(M) eq "O";
end intrinsic;

intrinsic Module(M::ModFrmAlg) -> ModDedLat
{ Returns the underlying module used to generate this space. }
	return M`L;
end intrinsic;

intrinsic BaseRing(M::ModFrmAlg) -> FldOrd
{ The base ring of the space of algebraic modular forms. }
	return M`K;
end intrinsic;

intrinsic InnerForm(M::ModFrmAlg) -> QuadSpace
{ Returns the ambient quadratic space associated with the space of algebraic
modular forms. }
	return InnerForm(QuadraticSpace(Module(M)));
end intrinsic;

intrinsic Genus(M::ModFrmAlg : BeCareful := true, Orbits := false) -> QuadSpace
{ Returns the genus associated to the underlying module used to construct
  this space. }
	// If already computed, return it.
	if assigned M`genus then return M`genus; end if;

	// Otherwise, compute the genus and return it.
	_ := GenusReps(M : BeCareful := BeCareful, Orbits := Orbits);
	return M`genus;
end intrinsic;

intrinsic AlgebraicModularForms(innerForm::AlgMatElt[RngInt]
		: isogenyType := "O") -> ModFrmAlg
{ Builds the space of orthogonal algebraic modular forms with respect to Gram
matrix over the integers. }
	// The rationals as a number field.
	K := RationalsAsNumberField();

	// The integers as a maximal order.
	R := Integers(K);

	// Coerce the inner form into coefficients of the maximal order.
	innerForm := ChangeRing(innerForm, R);

	return AlgebraicModularForms(innerForm : isogenyType := isogenyType);
end intrinsic;

intrinsic AlgebraicModularForms(innerForm::AlgMatElt[FldRat]) -> ModFrmAlg
{ Builds the space of orthogonal algebraic modular forms with respect to Gram
matrix over the integers. }
	try
		// Attempt to coerce the inner form to the integers.
		innerForm := ChangeRing(innerForm, Integers());
	catch e
		require false: "Inner form must be coercible to the integers.";
	end try;

	return AlgebraicModularForms(innerForm);
end intrinsic;

intrinsic AlgebraicModularForms(innerForm::AlgMatElt[RngOrd]
		: isogenyType := "O") -> ModFrmAlg
{ Builds the space of orthogonal algebraic modular forms with respect to the
specified Gram matrix. }
	// Build the quadratic space with specified inner form.
	V := AmbientQuadraticSpace(innerForm);

	// Retrieve the standard lattice for this quadratic space.
	L := StandardLattice(V);

	return AlgebraicModularForms(L, 0, isogenyType);
end intrinsic;

intrinsic AlgebraicModularForms(innerForm::AlgMatElt[FldNum]) -> ModFrmAlg
{ Builds the space of orthgonal algebraic modular forms with respect to the
specified Gram matrix. }
	// Retrieve the base ring of the inner form.
	R := Integers(BaseRing(innerForm));

	try
		// Attempt to coerce the inner form into the number ring.
		innerForm := ChangeRing(innerForm, R);
	catch e
		require false: "Inner form not coercible into number ring.";
	end try;

	return AlgebraicModularForms(innerForm);
end intrinsic;

intrinsic AlgebraicModularForms(innerForm::AlgMatElt) -> ModFrmAlg
{ Builds the space of orthogonal algebraic modular forms with respect to the
specified Gram matrix. This routine tries to convert the base ring to something
we can work with first, however. }
	// Get the base ring of the inner form.
	R := BaseRing(innerForm);

	try
		// Attempt to determine the integral structure of R.
		R := Integers(R);
		innerForm := ChangeRing(innerForm, R);
	catch e
		require false: "Invalid base ring for inner form.";
	end try;

	return AlgebraicModularForms(innerForm);
end intrinsic;

intrinsic AlgebraicModularForms(innerForm::AlgMatElt, isogenyType::MonStgElt)
	-> ModFrmAlg
{ Builds the space of algebraic modular forms. }
	return AlgebraicModularForms(innerForm, 0, isogenyType);
end intrinsic;

intrinsic AlgebraicModularForms(lat::Lat) -> ModFrmAlg
{ Builds the space of algebraic modular forms from the specified lattice. }
	return AlgebraicModularForms(GramMatrix(lat));
end intrinsic;

intrinsic AlgebraicModularForms(L::ModDedLat) -> ModFrmAlg
{ Computes the space of algebraic modular forms. }
	return AlgebraicModularForms(L, 0, "O");
end intrinsic;

intrinsic AlgebraicModularForms(
	lat::ModDedLat, weight::RngIntElt, isogenyType::MonStgElt)
		-> ModFrmAlg
{ Computes the space of algebraic modular forms with specified isogeny type and
weight given by homogeneous polynomials. }
	// Make sure the isogeny type is valid.
	require isogenyType in [ "SO", "O" ]:
		"Isogeny type must be (O)rthogonal or (S)pecial (O)rthogonal.";

	// Initialize the space of algebraic modular forms.
	M := New(ModFrmAlg);

	// The dimension of the ambient quadratic space.
	dim := Dimension(QuadraticSpace(lat));

	// The Cartan nae of the underlying Lie group.
	cartan := (dim mod 2 eq 1 select "B" else "D") cat
		IntegerToString(Floor(dim / 2));

	// Assign the underlying Lie group and standard lattice associated to
	//  the inner form.
	M`K := BaseRing(QuadraticSpace(lat));
	M`G := GroupOfLieType(cartan, M`K);
	M`L := lat;

	// Assign the isogeny type of the Lie group.
	M`isogenyType := isogenyType;

	// Assign the Hecke module for this instance.
	M`Hecke := New(ModHecke);
	M`Hecke`Ts := AssociativeArray();

	return M;
end intrinsic;

procedure ModFrmAlgInit(M : BeCareful := true, Force := false, Orbits := false)
	// If the representation space has already been computed, then this
	//  object has already been initialized, and we can simply return
	//  without any further computations.
	if assigned M`W then return; end if;

	// Compute genus representatives of the associated inner form.
	if Degree(BaseRing(QuadraticSpace(Module(M)))) eq 1 then
		computeGenusRepsQQ(M : BeCareful := BeCareful, Force := Force,
			Orbits := Orbits);
	else
		computeGenusRepsCN1(M : BeCareful := BeCareful, Force := Force);
	end if;
end procedure;

intrinsic Dimension(M::ModFrmAlg) -> RngIntElt
{ Returns the dimension of this vector space. }
	// Initialize this space of modular forms.
	ModFrmAlgInit(M);

	return #Representatives(Genus(M));
end intrinsic;

intrinsic HeckeEigenforms(M::ModFrmAlg) -> List
{ Returns a list of cusp forms associated to this space. }
	// Initialize space of modular forms if needed.
	ModFrmAlgInit(M);	

	// Display an error if no Hecke matrices have been computed yet.
	require IsDefined(M`Hecke`Ts, 1): "Compute some Hecke matrices first!";

	// Decompose eigenspace.
	spaces, reducible :=
		EigenspaceDecomposition(M`Hecke`Ts[1] : Warning := false);

	// A list of cusp forms.
	cuspForms := [* *];

	for space in spaces do
		// Extract the first basis vector of the eigenspace.
		basis := Basis(space);

		for vec in basis do
			// Construct an element of the modular space.
			mform := New(ModFrmAlgElt);

			// Assign parent modular space.
			mform`M := M;

			// Assign vector.
			mform`vec := vec;

			// Flag as cuspidal?
			mform`IsCuspidal := &+[ x : x in Eltseq(vec) ] eq 0;

			// Cusp forms are not Eistenstein.
			mform`IsEisenstein := not mform`IsCuspidal;

			// This is an eigenform if and only if the size
			//  of the subspace has dimension 1.
			mform`IsEigenform := #basis eq 1;

			// Add to list.
			Append(~cuspForms, mform);
		end for;
	end for;

	return cuspForms;
end intrinsic;

intrinsic CuspidalSubspace(M::ModFrmAlg) -> ModMatFldElt
{ Computes the cuspidal subspace of M. }
	// Initialize the space of algebraic modular forms.
	ModFrmAlgInit(M);

	// Retrieve the Eisenstein series.
	eis := EisensteinSeries(M);

	// The dimension of the space.
	dim := #GenusReps(M);

	// Compute the sizes of the automorphism groups of each of the genus
	//  representatives.
	aut := [ #AutomorphismGroup(L) : L in Representatives(Genus(M)) ];

	// Initialize the Hermitian inner product space in which the Hecke
	//  operators are self-adjoint.
	gram := ChangeRing(DiagonalMatrix(aut), Rationals());

	// The change-of-basis matrix.
	basis := Id(MatrixRing(Rationals(), dim));

	// Make the Eisenstein series the first basis vector.
	for i in [2..dim] do
		AddColumn(~gram, eis`vec[i], i, 1);
		AddRow(~gram, eis`vec[i], i, 1);
		AddRow(~basis, eis`vec[i], i, 1);
	end for;

	// Orthogonalize with respect to the Eisenstein series.
	for i in [2..dim] do
		scalar := -gram[1,i] / gram[1,1];
		AddColumn(~gram, scalar, 1, i);
		AddRow(~gram, scalar, 1, i);
		AddRow(~basis, scalar, 1, i);
	end for;

	// The normalized cuspidal basis.
	cuspBasis := [];

	// Normalize the basis vectors of the cuspidal subspace.
	for i in [2..dim] do
		// Retrieve the cuspical vector.
		vec := basis[i];

		// Find its pivot.
		pivot := 0; repeat pivot +:= 1; until vec[pivot] ne 0;

		// Normalize the vector add it to the list.
		Append(~cuspBasis, vec[pivot]^-1 * vec);
	end for;

	// Reduce the cuspidal basis to be as sparse as possible.
	cuspBasis := EchelonForm(Matrix(cuspBasis));

	return cuspBasis;
end intrinsic;

// TODO: Make this more general.
intrinsic CuspidalHeckeOperator(M::ModFrmAlg, p::RngIntElt) -> AlgMatElt
{ Computes the Hecke operator restricted to the cuspidal subspace. }
	// The Hecke operator at this prime.
	T := ChangeRing(HeckeOperator(M, p), Rationals());

	// The cuspidal subspace.
	C := CuspidalSubspace(M);

	// The restriction of the Hecke operator to the cuspidal subspace.
	T := Solution(C, Transpose(T * Transpose(C)));
	return T;
end intrinsic;


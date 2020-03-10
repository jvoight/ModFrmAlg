//freeze;

/****-*-magma-**************************************************************
                                                                            
                    Algebraic Modular Forms in Magma                          
                            Eran Assaf                                 
                                                                            
   FILE: struct.m (main structure file)

   Declaration file for the space of algebraic modular forms.

   02/28/20: started from the orthogonal modular forms structure
 
 ***************************************************************************/


///////////////////////////////////////////////////////////////////
//                                                               //
//    ModFrmAlg: The algebraic modular forms object.             //
//                                                               //
///////////////////////////////////////////////////////////////////

// Data type for implementation of algebraic modular forms.
declare type ModFrmAlg;
declare attributes ModFrmAlg:
	// The Lie group.
	G,

	// The weight, as a representation of G.
	W,

	// The level.
	K,

	// Isogeny type.
	isogenyType,

	// The inner form as a lattice.
	L,

	// Hecke data structure.
	Hecke,

	// The genus symbol for this lattice.
	genus,

	// The filename from which this space was loaded.
	filename;

declare type ModFrmAlgElt;
declare attributes ModFrmAlgElt:
	// Ambient modular space.
	M,

	// A vector representation of a modular form in M.
	vec,

	// Is this an eigenform?
	IsEigenform,

	// Is this a cusp form?
	IsCuspidal,

	// Is this an Eisenstein form?
	IsEisenstein,

	// Does the theta series vanish?
	IsInThetaKernel,

	// An associative array of eigenvalues (only used if this element is
	//  flagged as an eigenform).
	Eigenvalues;

declare type ModHecke;
declare attributes ModHecke:
	// A list of Hecke matrices.
	Ts,

	// Hecke Eigenforms.
	Eigenforms,

	// A shortcut to the Eisenstein series.
	EisensteinSeries;

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

declare attributes ModTupFld:
	// The Witt index of the form. This is defined to be the number of
	//  hyperbolic planes in the Witt decomposition of the quadratic form.
	WittIndex,

	// The Gram matrix of the form. In characteristic 2, this is not a
	//  Gram matrix, since the diagonal entries may be nonzero.
	GramMatrix,

	// The standardized Gram matrix, isometric to the GramMatrix attribute.
	//  This is the Witt decomposition of the form:
	//    Hyperbolic + Ansiotropic + Radical.
	// In characteristic 2, this is not a gram matrix, as the diagonal
	//  entries may be nonzero.
	GramMatrixStd,

	// The basis which connects GramMatrix with GramMatrixStd such that
	//  GramMatrixStd eq Transpose(Basis) * GramMatrix * Basis
	// In characteristic 2, the diagonal entries of GramMatrixStd and
	//  GramMatrix must first be zeroed out for the above identity to be
	//  valid.
	Basis,

	// The original quadratic form associated to GramMatrix.
	Q,

	// The standardized quadratic form associated to GramMatrixStd.
	QStd,

	// The dimension of the anisotropic subspace.
	AnisoDim,

	// The dimension of the radical.
	RadDim,

	// Stores a list of entries that keep track of the current state of any
	//  isotropic subspaces being enumerated for this quadratic space.
	ParamArray,

	// Ordering of the elements in the finite field.
	S,

	// A flag used to determine whether we will use symbolic vectors.
	Symbolic,

	// The primitive element of the finite field.
	PrimitiveElement;

declare type IsoParam;
declare attributes IsoParam:
	// A list of valid pivots.
	Pivots,

	// A pointer to the current pivot.
	PivotPtr,

	// The free variables that parameterize the isotropic subspaces with
	//  respect to our current pivot.
	FreeVars,

	// The parameters for the free variables for the current pivot.
	Params,

	// A matrix whose rows correspond to the parameterized isotropic
	//  subspaces.
	IsotropicParam;

// for backward compatiblity

declare type QuadSpaceAff;
declare attributes QuadSpaceAff:
	// The quadratic space.
	V,

	// The prime ideal.
	pR,

	// A uniformizing element of pR.
	pElt,

	// The finite field.
	F,

	// The characteristic.
	ch,

	// The quotient modulo pR^2.
	quot,

	// The projection map modulo pR.
	proj_pR,

	// The projection map modulo pR^2.
	proj_pR2,

	// Gram matrix modulo pR^2.
	quotGram,

	// The quadratic form modulo pR^2.
	Q_pR2;

declare type QuadSpace;
declare attributes QuadSpace:
	// The base field.
	F,

	// The base number ring.
	R,

	// The degree of the field extension.
	deg,

	// Class number of the field extension.
	classNo,

	// The inner form.
	innerForm,

	// The quadratic space as a vector space.
	V,

	// The quadratic form as a multinomial.
	Q,

	// The dimension.
	dim,

	// The quaternion algebras associated to this space (ternary only).
	QuaternionAlgebra,

	// Whether the form is definite or not.
	Definite,

	// The diagonalized Gram matrix over the field of fractions.
	Diagonal,

	// The basis for the diagonalized Gram matrix.
	DiagonalBasis,

	// The standard lattice for this quadratic space.
	stdLat;

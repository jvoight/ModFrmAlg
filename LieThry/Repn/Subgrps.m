freeze;

/* Contains a small database */

/* This was taken from LiE, with the exception of <A6,B3>, <C3, A1A1>, <A7, A3A3>, 
 * which are taken from W. McKay, J. Patera, and D. Sankoff, "The Computation of
 * Branching Rules for Representations of Semisimple Lie Algebras", pp. 235-278 
 * in: Robert E. Beck, Bernard Kolman (eds), "Computers in Nonassociative Rings 
 * and Algebras", Academic Press, Inc. (London) Ltd, 1977. (Note that the other
 * cases may be found there as well).
 */

SubGroups := [
    <"A1", [ Strings() | ]>,
    <"A2", [ "A1", "A1" ]>,
    <"A3", [ "A2", "B2", "A1A1" ]>,
    <"A4", [ "A3", "B2", "A1A2" ]>,
    <"A5", [ "A4", "A3", "C3", "A2", "A1A2", "A1A3", "A2A2" ]>,
    <"A6", [ "A5", "B3", "A1A4", "A2A3" ]>,
    <"A7", [ "A6", "C4", "D4", "A1A3", "A1A5", "A2A4", "A3A3" ]>,
    <"A8", [ "A7", "B4", "A2A2", "A1A6", "A2A5", "A3A4" ]>,
    <"B2", [ "A1", "A1A1" ]>,
    <"B3", [ "G2", "A1A1A1", "A3" ]>,
    <"B4", [ "A1", "A1A1", "B2A1A1", "A3A1", "D4" ]>,
    <"B5", [ "A1", "B3A1A1", "B2A3", "D4A1", "D5" ]>,
    <"B6", [ "A1", "B4A1A1", "B3A3", "D4B2", "D5A1", "D6" ]>,
    <"B7", [ "A3", "A1", "A1B2", "B5A1A1", "B4A3", "D4B3", "D5B2", "D6A1", "D7" ]>,
    <"B8", [ "A1", "B6A1A1", "B5A3", "D4B4", "D5B3", "D6B2", "D7A1", "D8" ]>,
    <"C2", [ "A1", "A1A1" ]>,
    <"C3", [ "A1", "A1A1", "B2A1" ]>,
    <"C4", [ "A1", "A1A1A1", "C3A1", "B2B2" ]>,
    <"C5", [ "A1", "A1B2", "C4A1", "C3B2" ]>,
    <"C6", [ "A1", "A1A3", "A1B2", "C5A1", "C4B2", "C3C3" ]>,
    <"C7", [ "A1", "A1B3", "C6A1", "C5B2", "C4C3" ]>,
    <"C8", [ "B2", "A1", "A1D4", "C7A1", "C6B2", "C5C3", "C4C4" ]>,
    <"D3", [ "A2", "B2", "A1A1" ]>,
    <"D4", [ "B3", "A2", "A1B2", "A1A1A1A1" ]>,
    <"D5", [ "B4", "B2", "A1B3", "B2B2", "A3A1A1" ]>,
    <"D6", [ "B5", "A1C3", "A1B4", "B2B3", "A1A1A1", "D4A1A1", "A3A3" ]>,
    <"D7", [ "B6", "C3", "B2", "G2", "A1B5", "B2B4", "B3B3", "D5A1A1", "D4A3" ]>,
    <"D8", [ "B7", "B4", "A1C4", "A1B6", "B2B5", "B3B4", "B2B2", "D6A1A1", "D5A3", "D4D4" ]>,
    <"E6", [ "C4", "F4", "A2", "G2", "A2G2", "A5A1", "A2A2A2" ]>,
    <"E7", [ "A2", "A1", "A1", "A1F4", "G2C3", "A1G2", "A1A1", "D6A1", "A7", "A5A2" ]>,
    <"E8", [ "G2F4", "C2", "A1A2", "A1", "A1", "A1", "D8", "A8", "A4A4", "E6A2", "E7A1" ]>,
    <"F4", [ "A1", "A1G2", "C3A1", "A2A2", "B4" ]>,
    <"G2", [ "A1", "A2", "A1A1" ]>
];

RestrictionMatrices := [
    <"A1", []>,
    <"A2", [ [[1],[1]], [[2],[0]] ]>,
    <"A3", [ [[1,0],[1,0],[0,1]], [[0,1],[1,0],[0,1]], [[1,1],[0,2],[1,1]] ]>,
    <"A4", [ [[1,0,0],[0,1,0],[0,1,0],[0,0,1]], [[1,0],[0,2],[0,2],[1,0]],
    [[0,1,0],[1,1,0],[1,0,1],[0,0,1]] ]>,
    <"A5", [ [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,1,0],[0,0,0,1]],
    [[0,1,0],[1,0,1],[0,0,2],[1,0,1],[0,1,0]],
    [[1,0,0],[0,1,0],[0,0,1],[0,1,0],[1,0,0]], [[0,2],[1,2],[3,0],[2,1],[2,0]],
    [[1,1,0],[0,2,0],[1,1,1],[0,0,2],[1,0,1]],
    [[0,1,0,0],[0,0,1,0],[1,0,1,0],[0,0,1,0],[0,0,0,1]],
    [[0,0,1,0],[1,0,1,0],[0,1,1,0],[0,1,0,1],[0,0,0,1]] ]>,
    <"A6", [ [[1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,0,0,1]], 
    [[1,0,0],[0,1,0],[0,0,2],[0,0,2],[0,1,0],[1,0,0]],
    [[0,1,0,0,0],[0,0,1,0,0],[1,0,1,0,0],[1,0,0,1,0],[0,0,0,1,0],[0,0,0,0,1]],
    [[0,0,1,0,0],[1,0,1,0,0],[1,0,0,1,0],[0,1,0,1,0],[0,1,0,0,1],[0,0,0,0,1]] ]>,
    <"A7", [ [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1]], [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[0,0,1,0],[0,1,0,0],[1,0,0,0]], [[1,0,0,0],[0,1,0,0],[0,0,1,1],[0,0,0,2],[0,0,1,1],[0,1,0,0],[1,0,0,0]], [[1,1,0,0],[0,2,0,0],[1,1,1,0],[0,0,2,0],[1,0,1,1],[0,0,0,2],[1,0,0,1]], [[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[1,0,0,1,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1]], [[0,0,1,0,0,0],[0,0,0,1,0,0],[1,0,0,1,0,0],[1,0,0,0,1,0],[0,1,0,0,1,0],[0,0,0,0,1,0],[0,0,0,0,0,1]],
    [[0,0,0,1,0,0],[1,0,0,1,0,0],[1,0,0,0,1,0],[0,1,0,0,1,0],[0,0,1,0,1,0],[0,0,1,0,0,1],[0,0,0,0,0,1]] ]>,
    <"A8", [ [[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1]],
    [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,2],[0,0,0,2],[0,0,1,0],[0,1,0,0],[1,0,0,0]], [[1,0,1,0],[0,1,2,0],[1,1,1,1],[1,0,2,1],[0,1,1,2],[1,1,1,1],[1,0,0,2],[0,1,0,1]], [[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[1,0,0,1,0,0,0],[1,0,0,0,1,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1]],
    [[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[1,0,0,1,0,0,0],[1,0,0,0,1,0,0],[0,1,0,0,1,0,0],[0,1,0,0,0,1,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1]],
    [[0,0,0,1,0,0,0],[1,0,0,1,0,0,0],[1,0,0,0,1,0,0],[0,1,0,0,1,0,0],[0,1,0,0,0,1,0],[0,0,1,0,0,1,0],[0,0,1,0,0,0,1],[0,0,0,0,0,0,1]] ]>,
    <"B2", [ [[4],[3]], [[1,1],[0,1]] ]>,
    <"B3", [ [[1,0],[0,1],[1,0]], [[0,1,1],[0,0,2],[1,0,1]],
    [[0,1,0],[1,0,1],[0,0,1]] ]>,
    <"B4", [ [[8],[14],[18],[10]], [[2,2],[2,4],[4,4],[1,3]],
    [[0,0,1,1],[0,0,0,2],[1,0,0,2],[0,1,0,1]],
    [[0,1,0,0],[1,0,1,0],[0,0,2,0],[0,0,1,1]],
    [[1,0,0,0],[0,1,0,0],[0,0,1,1],[0,0,0,1]] ]>,
    <"B5", [ [[10],[18],[24],[28],[15]], [[0,0,0,1,1],[0,0,0,0,2],[1,0,0,0,2],[0,1,0,0,2],[0,0,1,0,1]], [[0,0,0,1,0],[0,0,1,0,1],[0,0,0,0,2],[1,0,0,0,2],[0,1,0,0,1]], [[1,0,0,0,0],[0,1,0,0,0],[0,0,1,1,0],[0,0,0,2,0],[0,0,0,1,1]],
    [[1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,1],[0,0,0,0,1]] ]>,
    <"B6", [ [[12],[22],[30],[36],[40],[21]],
    [[0,0,0,0,1,1],[0,0,0,0,0,2],[1,0,0,0,0,2],[0,1,0,0,0,2],[0,0,1,0,0,2],[0,0,0,1,0,1]], [[0,0,0,0,1,0],[0,0,0,1,0,1],[0,0,0,0,0,2],[1,0,0,0,0,2],[0,1,0,0,0,2],[0,0,1,0,0,1]], [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,1,0,0],[0,0,0,2,0,0],[0,0,0,2,1,0],[0,0,0,1,0,1]], [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,1,0],[0,0,0,0,2,0],[0,0,0,0,1,1]], [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,1],[0,0,0,0,0,1]] ]>,
    <"B7", [ [[1,0,1],[0,1,2],[1,2,1],[1,1,3],[0,3,2],[2,2,2],[1,1,1]],
    [[14],[26],[36],[44],[50],[54],[28]], [[2,1,0],[2,2,0],[4,1,2],[2,2,2],[2,1,4],[4,1,4],[1,0,3]], [[0,0,0,0,0,1,1],[0,0,0,0,0,0,2],[1,0,0,0,0,0,2],[0,1,0,0,0,0,2],[0,0,1,0,0,0,2],[0,0,0,1,0,0,2],[0,0,0,0,1,0,1]],
    [[0,0,0,0,0,1,0],[0,0,0,0,1,0,1],[0,0,0,0,0,0,2],[1,0,0,0,0,0,2],[0,1,0,0,0,0,2],[0,0,1,0,0,0,2],[0,0,0,1,0,0,1]], [[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,1,1,0,0,0],[0,0,0,2,0,0,0],[0,0,0,2,1,0,0],[0,0,0,2,0,1,0],[0,0,0,1,0,0,1]],
    [[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,1,0,0],[0,0,0,0,2,0,0],[0,0,0,0,2,1,0],[0,0,0,0,1,0,1]], [[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,1,0],[0,0,0,0,0,2,0],[0,0,0,0,0,1,1]],
    [[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,1],[0,0,0,0,0,0,1]] ]>,
    <"B8", [ [[16],[30],[42],[52],[60],[66],[70],[36]],
    [[0,0,0,0,0,0,1,1],[0,0,0,0,0,0,0,2],[1,0,0,0,0,0,0,2],[0,1,0,0,0,0,0,2],[0,0,1,0,0,0,0,2],[0,0,0,1,0,0,0,2],[0,0,0,0,1,0,0,2],[0,0,0,0,0,1,0,1]],
    [[0,0,0,0,0,0,1,0],[0,0,0,0,0,1,0,1],[0,0,0,0,0,0,0,2],[1,0,0,0,0,0,0,2],[0,1,0,0,0,0,0,2],[0,0,1,0,0,0,0,2],[0,0,0,1,0,0,0,2],[0,0,0,0,1,0,0,1]],
    [[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,1,0,0,0,0],[0,0,0,2,0,0,0,0],[0,0,0,2,1,0,0,0],[0,0,0,2,0,1,0,0],[0,0,0,2,0,0,1,0],[0,0,0,1,0,0,0,1]],
    [[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,1,0,0,0],[0,0,0,0,2,0,0,0],[0,0,0,0,2,1,0,0],[0,0,0,0,2,0,1,0],[0,0,0,0,1,0,0,1]],
    [[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,1,0,0],[0,0,0,0,0,2,0,0],[0,0,0,0,0,2,1,0],[0,0,0,0,0,1,0,1]],
    [[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,1,0],[0,0,0,0,0,0,2,0],[0,0,0,0,0,0,1,1]],
    [[1,0,0,0,0,0,0,0],[0,1,0,0,0,0,0,0],[0,0,1,0,0,0,0,0],[0,0,0,1,0,0,0,0],[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,1],[0,0,0,0,0,0,0,1]] ]>,
    <"C2", [ [[3],[4]], [[0,1],[1,1]] ]>,
    <"C3", [ [[5],[8],[9]], [[1,2],[0,4],[1,4]], [[0,0,1],[0,1,1],[1,0,1]] ]>,
    <"C4", [ [[7],[12],[15],[16]], [[1,1,1],[0,2,2],[1,1,3],[2,2,2]],
    [[0,0,0,1],[1,0,0,1],[0,1,0,1],[0,0,1,1]],
    [[0,0,0,1],[0,0,1,0],[0,1,1,0],[1,0,1,0]] ]>,
    <"C5", [ [[9],[16],[21],[24],[25]], [[1,1,0],[0,2,0],[1,1,2],[0,0,4],[1,0,4]],
    [[0,0,0,0,1],[1,0,0,0,1],[0,1,0,0,1],[0,0,1,0,1],[0,0,0,1,1]],
    [[0,0,0,0,1],[0,0,0,1,0],[1,0,0,1,0],[0,1,0,1,0],[0,0,1,1,0]] ]>,
    <"C6", [ [[11],[20],[27],[32],[35],[36]],
    [[1,0,1,0],[0,0,2,0],[1,1,1,1],[0,2,0,2],[1,1,0,3],[2,2,0,2]],
    [[2,0,1],[2,0,2],[4,1,1],[2,1,2],[2,2,1],[4,1,2]],
    [[0,0,0,0,0,1],[1,0,0,0,0,1],[0,1,0,0,0,1],[0,0,1,0,0,1],[0,0,0,1,0,1],[0,0,0,0,1,1]], [[0,0,0,0,0,1],[0,0,0,0,1,0],[1,0,0,0,1,0],[0,1,0,0,1,0],[0,0,1,0,1,0],[0,0,0,1,1,0]], [[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1],[1,0,0,0,0,1],[0,1,0,0,0,1],[0,0,1,0,0,1]] ]>,
    <"C7", [ [[13],[24],[33],[40],[45],[48],[49]],
    [[1,1,0,0],[0,2,0,0],[1,1,1,0],[0,0,2,0],[1,0,1,2],[0,0,0,4],[1,0,0,4]],
    [[0,0,0,0,0,0,1],[1,0,0,0,0,0,1],[0,1,0,0,0,0,1],[0,0,1,0,0,0,1],[0,0,0,1,0,0,1],[0,0,0,0,1,0,1],[0,0,0,0,0,1,1]], [[0,0,0,0,0,0,1],[0,0,0,0,0,1,0],[1,0,0,0,0,1,0],[0,1,0,0,0,1,0],[0,0,1,0,0,1,0],[0,0,0,1,0,1,0],[0,0,0,0,1,1,0]],
    [[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1],[1,0,0,0,0,0,1],[0,1,0,0,0,0,1],[0,0,1,0,0,0,1],[0,0,0,1,0,0,1]] ]>,
    <"C8", [ [[1,1],[0,4],[2,3],[2,4],[2,5],[0,8],[1,7],[2,6]],
    [[15],[28],[39],[48],[55],[60],[63],[64]],
    [[1,1,0,0,0],[0,2,0,0,0],[1,1,1,0,0],[0,0,2,0,0],[1,0,1,1,1],[0,0,0,2,2],[1,0,0,1,3],[2,0,0,2,2]], [[0,0,0,0,0,0,0,1],[1,0,0,0,0,0,0,1],[0,1,0,0,0,0,0,1],[0,0,1,0,0,0,0,1],[0,0,0,1,0,0,0,1],[0,0,0,0,1,0,0,1],[0,0,0,0,0,1,0,1],[0,0,0,0,0,0,1,1]], [[0,0,0,0,0,0,0,1],[0,0,0,0,0,0,1,0],[1,0,0,0,0,0,1,0],[0,1,0,0,0,0,1,0],[0,0,1,0,0,0,1,0],[0,0,0,1,0,0,1,0],[0,0,0,0,1,0,1,0],[0,0,0,0,0,1,1,0]],
    [[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,1],[1,0,0,0,0,0,0,1],[0,1,0,0,0,0,0,1],[0,0,1,0,0,0,0,1],[0,0,0,1,0,0,0,1],[0,0,0,0,1,0,0,1]],
    [[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,0],[0,0,0,0,0,0,0,1],[1,0,0,0,0,0,0,1],[0,1,0,0,0,0,0,1],[0,0,1,0,0,0,0,1],[0,0,0,1,0,0,0,1]] ]>,
    <"D3", [ [[1,0],[1,0],[0,1]], [[1,0],[0,1],[0,1]], [[0,2],[1,1],[1,1]] ]>,
    <"D4", [ [[0,0,1],[0,1,0],[0,0,1],[1,0,0]], [[1,1],[0,3],[1,1],[1,1]],
    [[1,0,1],[2,1,0],[0,1,0],[1,0,1]], [[0,0,1,1],[0,0,0,2],[0,1,0,1],[1,0,0,1]] ]>,    
	<"D5", [ [[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[0,0,0,1]],
    [[0,2],[1,2],[0,4],[1,1],[1,1]], [[0,1,0,0],[0,0,1,0],[0,0,0,2],[1,0,0,1],[1,0,0,1]], [[1,0,0,0],[0,2,0,0],[0,2,1,0],[0,1,0,1],[0,1,0,1]],
    [[0,0,0,1,1],[0,0,0,0,2],[0,1,0,0,2],[0,0,1,0,1],[1,0,0,0,1]] ]>,
    <"D6", [ [[1,0,0,0,0],[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,0,0,1],[0,0,0,0,1]], [[1,1,0,0],[2,0,1,0],[1,1,1,0],[2,1,0,1],[0,0,0,1],[1,0,1,0]],
    [[0,1,0,0,0],[0,0,1,0,0],[0,0,0,1,0],[0,0,0,0,2],[1,0,0,0,1],[1,0,0,0,1]],
    [[0,0,1,0,0],[0,0,0,1,0],[1,0,0,1,0],[1,0,0,0,2],[0,1,0,0,1],[0,1,0,0,1]],
    [[2,1,1],[4,2,0],[6,1,1],[6,2,2],[4,0,1],[4,1,0]],
    [[0,0,0,0,1,1],[0,0,0,0,0,2],[1,0,0,0,0,2],[0,1,0,0,0,2],[0,0,0,1,0,1],[0,0,1,0,0,1]], [[0,0,0,0,1,0],[0,0,0,1,0,1],[0,0,0,0,0,2],[0,1,0,0,0,2],[0,0,1,0,0,1],[1,0,0,0,0,1]] ]>,
    <"D7", [ [[1,0,0,0,0,0],[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,1],[0,0,0,0,0,1]], [[0,1,0],[1,0,1],[0,0,2],[1,1,1],[0,3,0],[1,1,0],[1,1,0]], [[2,0],[2,2],[3,2],[1,6],[3,4],[1,3],[1,3]],
    [[0,1],[3,0],[4,0],[3,1],[5,0],[1,1],[1,1]],
    [[0,1,0,0,0,0],[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[0,0,0,0,0,2],[1,0,0,0,0,1],[1,0,0,0,0,1]], [[0,0,1,0,0,0],[0,0,0,1,0,0],[0,0,0,0,1,0],[1,0,0,0,1,0],[1,0,0,0,0,2],[0,1,0,0,0,1],[0,1,0,0,0,1]],
    [[1,0,0,0,0,0],[1,0,0,1,0,0],[0,1,0,1,0,0],[0,1,0,0,1,0],[0,0,2,0,1,0],[0,0,1,0,0,1],[0,0,1,0,0,1]], [[0,0,0,0,0,1,1],[0,0,0,0,0,0,2],[1,0,0,0,0,0,2],[0,1,0,0,0,0,2],[0,0,1,0,0,0,2],[0,0,0,0,1,0,1],[0,0,0,1,0,0,1]],
    [[0,0,0,0,0,1,0],[0,0,0,0,1,0,1],[0,0,0,0,0,0,2],[1,0,0,0,0,0,2],[0,1,0,0,0,0,2],[0,0,0,1,0,0,1],[0,0,1,0,0,0,1]] ]>,
    <"D8", [ [[1,0,0,0,0,0,0],[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,1],[0,0,0,0,0,0,1]],
    [[0,0,0,1],[0,0,1,0],[0,1,0,1],[1,0,0,2],[1,1,0,1],[0,1,0,2],[1,0,0,1],[0,0,1,0]], [[1,1,0,0,0],[2,0,1,0,0],[1,1,1,0,0],[2,1,0,1,0],[1,0,1,1,0],[2,0,1,0,1],[0,0,0,0,1],[1,0,0,1,0]], [[0,1,0,0,0,0,0],[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[0,0,0,0,0,0,2],[1,0,0,0,0,0,1],[1,0,0,0,0,0,1]],
    [[0,0,1,0,0,0,0],[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[0,0,0,0,0,1,0],[1,0,0,0,0,1,0],[1,0,0,0,0,0,2],[0,1,0,0,0,0,1],[0,1,0,0,0,0,1]],
    [[0,0,0,1,0,0,0],[0,0,0,0,1,0,0],[1,0,0,0,1,0,0],[1,0,0,0,0,1,0],[0,1,0,0,0,1,0],[0,1,0,0,0,0,2],[0,0,1,0,0,0,1],[0,0,1,0,0,0,1]],
    [[0,1,0,1],[0,2,1,0],[1,1,1,1],[1,2,0,2],[2,1,1,1],[1,2,1,2],[0,2,1,0],[1,1,0,1]], [[0,0,0,0,0,0,1,1],[0,0,0,0,0,0,0,2],[1,0,0,0,0,0,0,2],[0,1,0,0,0,0,0,2],[0,0,1,0,0,0,0,2],[0,0,0,1,0,0,0,2],[0,0,0,0,0,1,0,1],[0,0,0,0,1,0,0,1]],
    [[0,0,0,0,0,0,1,0],[0,0,0,0,0,1,0,1],[0,0,0,0,0,0,0,2],[1,0,0,0,0,0,0,2],[0,1,0,0,0,0,0,2],[0,0,1,0,0,0,0,2],[0,0,0,0,1,0,0,1],[0,0,0,1,0,0,0,1]],
    [[0,0,0,0,1,0,0,0],[0,0,0,0,0,1,0,0],[0,0,0,0,0,0,1,1],[0,0,0,0,0,0,0,2],[1,0,0,0,0,0,0,2],[0,1,0,0,0,0,0,2],[0,0,0,1,0,0,0,1],[0,0,1,0,0,0,0,1]] ]>,
    <"E6", [ [[0,1,0,0],[0,0,0,1],[1,0,1,0],[0,0,2,0],[1,0,1,0],[0,1,0,0]],
    [[0,0,0,1],[1,0,0,0],[0,0,1,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],
    [[2,2],[1,4],[2,5],[5,5],[5,2],[2,2]], [[2,0],[1,1],[2,1],[5,0],[2,1],[2,0]],
    [[1,0,1,0],[1,1,1,0],[2,0,0,1],[1,1,1,1],[0,2,0,1],[0,1,1,0]],
    [[0,0,0,0,1,1],[0,0,0,0,0,2],[0,0,0,1,0,2],[0,0,1,0,0,3],[0,1,0,0,0,2],[1,0,0,0,0,1]], [[0,0,0,1,0,1],[0,0,0,0,1,1],[0,0,1,0,0,2],[0,0,0,0,0,3],[0,1,0,0,0,2],[1,0,0,0,0,1]] ]>,
    <"E7", [ [[4,4],[7,4],[9,6],[11,11],[10,7],[6,6],[6,0]],
    [[34],[49],[66],[96],[75],[52],[27]], [[26],[37],[50],[72],[57],[40],[21]],
    [[0,1,0,0,0],[1,0,0,1,0],[0,0,1,0,0],[2,0,1,0,1],[1,0,0,1,1],[2,0,0,1,0],[1,0,0,0,1]], [[1,0,0,1,0],[0,1,0,0,1],[2,0,1,0,1],[1,1,1,1,1],[1,1,1,1,0],[2,0,0,1,0],[1,0,1,0,0]], [[2,2,0],[3,1,1],[4,2,1],[4,4,1],[5,4,0],[4,1,1],[1,0,1]],
    [[4,6],[8,7],[10,10],[18,12],[12,11],[8,8],[6,3]],
    [[0,0,0,0,0,0,2],[0,0,0,0,0,1,2],[0,0,0,0,1,0,3],[0,0,0,1,0,0,4],[0,0,1,0,0,0,3],[0,1,0,0,0,0,2],[1,0,0,0,0,0,1]], [[1,0,0,0,0,0,1],[0,0,0,0,0,0,2],[0,1,0,0,0,0,2],[0,0,1,0,0,0,3],[0,0,0,1,0,0,2],[0,0,0,0,1,0,1],[0,0,0,0,0,1,0]],
    [[0,0,0,0,0,1,1],[0,0,0,0,1,0,2],[0,0,0,0,0,0,3],[0,0,0,1,0,0,4],[0,0,1,0,0,0,3],[0,1,0,0,0,0,2],[1,0,0,0,0,0,1]] ]>,
    <"E8", [ [[1,0,0,0,1,0],[0,1,0,1,0,0],[2,0,0,1,0,1],[1,1,0,1,1,1],[1,1,1,0,1,1],[2,0,1,0,1,0],[1,0,1,0,0,1],[1,0,0,0,0,1]],
    [[4,4],[6,6],[8,8],[16,9],[12,8],[8,7],[8,3],[2,3]],
    [[8,2,2],[12,3,3],[16,4,4],[22,8,5],[16,6,6],[14,4,4],[10,4,1],[6,1,1]],
    [[72],[106],[142],[210],[172],[132],[90],[46]],
    [[60],[88],[118],[174],[142],[108],[74],[38]],
    [[92],[136],[182],[270],[220],[168],[114],[58]],
    [[2,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,1],[3,0,0,0,0,0,1,0],[4,0,0,0,0,1,0,0],[3,0,0,0,1,0,0,0],[2,0,0,1,0,0,0,0],[1,0,1,0,0,0,0,0],[0,1,0,0,0,0,0,0]],
    [[0,0,0,0,0,0,1,1],[0,0,0,0,0,0,0,3],[0,0,0,0,0,1,0,3],[0,0,0,0,1,0,0,5],[0,0,0,1,0,0,0,4],[0,0,1,0,0,0,0,3],[0,1,0,0,0,0,0,2],[1,0,0,0,0,0,0,1]],
    [[0,0,0,2,1,0,0,0],[0,0,0,3,0,0,0,1],[0,0,0,4,0,1,0,0],[0,0,0,6,0,0,1,0],[0,0,0,5,0,0,0,0],[0,0,1,3,0,0,0,0],[0,1,0,2,0,0,0,0],[1,0,0,1,0,0,0,0]],
    [[0,0,0,0,0,1,0,2],[0,1,0,0,0,0,0,3],[0,0,0,0,1,0,0,4],[0,0,0,1,0,0,0,6],[0,0,1,0,0,0,0,5],[1,0,0,0,0,0,0,4],[0,0,0,0,0,0,0,3],[0,0,0,0,0,0,1,1]],
    [[1,0,0,0,0,0,0,2],[0,1,0,0,0,0,0,3],[0,0,1,0,0,0,0,4],[0,0,0,1,0,0,0,6],[0,0,0,0,1,0,0,5],[0,0,0,0,0,1,0,4],[0,0,0,0,0,0,1,3],[0,0,0,0,0,0,0,2]] ]>,
    <"F4", [ [[22],[42],[30],[16]], [[4,1,0],[4,1,1],[4,0,1],[2,1,0]],
    [[0,0,0,2],[0,0,1,3],[0,1,0,2],[1,0,0,1]],
    [[0,0,1,1],[0,0,0,3],[0,1,0,2],[1,0,0,1]],
    [[0,1,0,0],[1,0,1,0],[1,0,0,1],[1,0,0,0]] ]>,
    <"G2", [ [[6],[10]], [[0,1],[1,1]], [[1,1],[0,2]] ]>
];


intrinsic LiEMaximalSubgroups() -> SeqEnum
{ Return the database of subgroups }
	return SubGroups;
end intrinsic;

intrinsic MaximalSubgroups( G::MonStgElt ) -> SeqEnum[MonStgElt]
{ The types of the maximal proper subgroups of g, represented as a sequence
 of strings. Result is obtained from a small database, therefore G
    must be simple and of rank at most 8.

  Types for which more than one conjugacy class of subgroups exist have 
	repeated occurences.
}
	nm := G; nm := &cat( [ c : c in Eltseq(nm) | c ne " " ]);
	for s in SubGroups do
		if (s[1] eq nm) then return s[2]; end if;
	end for;

	error "Could not find ", nm, " in subgroup database.";
end intrinsic;


intrinsic RestrictionMatrix( nmG::MonStgElt, nmH::MonStgElt : Index := -1  ) -> AlgMatElt
{ The restriction matrix for the i-th maximal proper subgroup with type H of G, 
  which is obtained from a small database. 

  In the case where there is more than one conjugacy class of subgroups of type H of G, 
  the optional parameter must be set.
}
	posG := 1;
	while (posG le #SubGroups) do
		if (SubGroups[posG][1] eq nmG) then break; end if;
		posG +:= 1;
	end while;

	error if (posG gt #SubGroups), "Could not find ", nmG, " in subgroup database.";

	lst := SubGroups[posG][2];
	pss := [ i : i in [1..#lst] | lst[i] eq nmH ];
	if (Index ne -1 and #pss gt 0 and Index gt #pss) then
	    mp1 := #pss eq 1 select "" else "s";
	    mp2 := #pss eq 1 select "s" else "";
	    error "Only " cat IntegerToString(#pss) cat " subgroup" cat mp1 cat " of type " cat nmH cat " exist" cat mp2 cat ".";
	end if;
	
	if (#pss eq 0) then
		error "No subgroup of ", nmG, " has type ", nmH;
	elif (#pss eq 1) then
		return Matrix(RestrictionMatrices[posG][2][pss[1]]);
	elif (#pss gt 1 and Index eq -1) then
		error "More than one subgroup of " cat nmG cat " of type " cat nmH cat " exists; Please specify which one you want using the Index parameter";
	else
		return Matrix(RestrictionMatrices[posG][2][pss[Index]]);
	end if;
end intrinsic;


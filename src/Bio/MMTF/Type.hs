module Bio.MMTF.Type where

import           Control.DeepSeq (NFData (..))
import           Data.Int        (Int32, Int8)
import           Data.Text       (Text)
import           Data.Vector     (Vector)
import           GHC.Generics    (Generic)

import           Bio.Structure   (SecondaryStructure)

-- | Transformation matrix
--
data M44 = M44 Float Float Float Float
               Float Float Float Float
               Float Float Float Float
               Float Float Float Float
  deriving (Show, Eq, Generic, NFData)

-- | Unit cell data
--
data UnitCell = UnitCell { ucA     :: !Float -- ^ length of side 'a'
                         , ucB     :: !Float -- ^ length of side 'b'
                         , ucC     :: !Float -- ^ length of side 'c'
                         , ucAlpha :: !Float -- ^ alpha angle in degrees
                         , ucBeta  :: !Float -- ^ beta angle in degrees
                         , ucGamma :: !Float -- ^ gamma angle in degrees
                         }
  deriving (Show, Eq, Generic, NFData)

-- | Transform data
--
data Transform = Transform { chainIndexList :: !(Vector Int32) -- ^ indices into the 'chainIdList' and 'chainNameList' fields
                           , matrix         :: !M44            -- ^ 4x4 transformation matrix
                           }
  deriving (Show, Eq, Generic, NFData)

-- | Assembly data
--
data Assembly = Assembly { transformList :: !(Vector Transform) -- ^ List of transform objects
                         , assemblyName  :: !Text               -- ^ Name of the biological assembly
                         }
  deriving (Show, Eq, Generic, NFData)

-- | Entity data
--
data Entity = Entity { entityChainIndexList :: !(Vector Int32) -- ^ indices into the 'chainIdList' and 'chainNameList' fields
                     , entityDescription    :: !Text           -- ^ Description of the entity
                     , entityType           :: !Text           -- ^ Name of the entity type
                     , entitySequence       :: !Text           -- ^ Sequence of the full construct in one-letter-code
                     }
  deriving (Show, Eq, Generic, NFData)

-- | Group type data
--
data GroupType = GroupType { gtFormalChargeList :: !(Vector Int32)          -- ^ List of formal charges
                           , gtAtomNameList     :: !(Vector Text)           -- ^ List of atom names
                           , gtElementList      :: !(Vector Text)           -- ^ List of elements
                           , gtBondAtomList     :: !(Vector (Int32, Int32)) -- ^ List of bonded atom indices
                           , gtBondOrderList    :: !(Vector Int32)          -- ^ List of bond orders
                           , gtGroupName        :: !Text                    -- ^ The name of the group
                           , gtSingleLetterCode :: !Char                    -- ^ The single letter code
                           , gtChemCompType     :: !Text                    -- ^ The chemical component type
                           }
  deriving (Show, Eq, Generic, NFData)

-- | MMTF format data
--
data FormatData = FormatData { mmtfVersion  :: !Text -- ^ The version number of the specification the file adheres to
                             , mmtfProducer :: !Text -- ^ The name and version of the software used to produce the file
                             }
  deriving (Show, Eq, Generic, NFData)

-- | Structure data
--
data StructureData = StructureData { title               :: !Text                    -- ^ A short description of the structural data included in the file
                                   , structureId         :: !Text                    -- ^ An ID for the structure, for example the PDB ID if applicable
                                   , depositionDate      :: !Text                    -- ^ A date that relates to the deposition of the structure in a database
                                   , releaseDate         :: !Text                    -- ^ A date that relates to the release of the structure in a database
                                   , numBonds            :: !Int32                   -- ^ The overall number of bonds
                                   , numAtoms            :: !Int32                   -- ^ The overall number of atoms in the structure
                                   , numGroups           :: !Int32                   -- ^ The overall number of groups in the structure
                                   , numChains           :: !Int32                   -- ^ The overall number of chains in the structure
                                   , numModels           :: !Int32                   -- ^ The overall number of models in the structure
                                   , spaceGroup          :: !Text                    -- ^ The Hermann-Mauguin space-group symbol
                                   , unitCell            :: !(Maybe UnitCell)        -- ^ Array of six values defining the unit cell
                                   , ncsOperatorList     :: !(Vector M44)            -- ^ List of 4x4 transformation matrices (transformation matrices describe noncrystallographic symmetry operations needed to create all molecules in the unit cell)
                                   , bioAssemblyList     :: !(Vector Assembly)       -- ^ List of instructions on how to transform coordinates for an array of chains to create (biological) assemblies
                                   , entityList          :: !(Vector Entity)         -- ^ List of unique molecular entities within the structure
                                   , resolution          :: !(Maybe Float)           -- ^ The experimental resolution in Angstrom
                                   , rFree               :: !(Maybe Float)           -- ^ The R-free value
                                   , rWork               :: !(Maybe Float)           -- ^ The R-work value
                                   , experimentalMethods :: !(Vector Text)           -- ^ List of experimental methods employed for structure determination
                                   , bondAtomList        :: !(Vector (Int32, Int32)) -- ^ Pairs of values represent indices of covalently bonded atoms [binary (type 4)]
                                   , bondOrderList       :: !(Vector Int8)           -- ^ List of bond orders for bonds in 'bondAtomList' [binary (type 2)]
                                   }
  deriving (Show, Eq, Generic, NFData)

-- | Models data
--
data ModelData = ModelData { chainsPerModel :: !(Vector Int32) -- ^ List of the number of chains in each model
                           }
  deriving (Show, Eq, Generic, NFData)

-- | Chains data
--
data ChainData = ChainData { groupsPerChain :: !(Vector Int32)       -- ^ List of the number of groups (aka residues) in each chain
                           , chainIdList    :: !(Vector Text)        -- ^ List of chain IDs [binary (type 5)]
                           , chainNameList  :: !(Vector Text)        -- ^ List of chain names [binary (type 5)]
                           }
  deriving (Show, Eq, Generic, NFData)

-- | Groups data
--
data GroupData = GroupData { groupList         :: !(Vector GroupType)              -- ^ List of groupType objects
                           , groupTypeList     :: !(Vector Int32)                  -- ^ List of pointers to 'groupType' entries in 'groupList' by their keys [binary (type 4)]
                           , groupIdList       :: !(Vector Int32)                  -- ^ List of group (residue) numbers [binary (type 8)]
                           , secStructList     :: !(Vector SecondaryStructure)     -- ^ List of secondary structure assignments [binary (type 2)]
                           , insCodeList       :: !(Vector Text)                   -- ^ List of insertion codes, one for each group (residue) [binary (type 6)]
                           , sequenceIndexList :: !(Vector Int32)                  -- ^ List of indices that point into the sequence property of an entity object in the 'entityList' field that is associated with the chain the group belongs to [binary (type 8)]
                           }
  deriving (Show, Eq, Generic, NFData)

-- | Atoms data
--
data AtomData = AtomData { atomIdList    :: !(Vector Int32)        -- ^ List of atom serial numbers [binary (type 8)]
                         , altLocList    :: !(Vector Text)         -- ^ List of alternate location labels, one for each atom [binary (type 6)]
                         , bFactorList   :: !(Vector Float)        -- ^ List of atom B-factors in in A^2, one for each atom [binary (type 10)]
                         , xCoordList    :: !(Vector Float)        -- ^ List of x atom coordinates in A, one for each atom [binary (type 10)]
                         , yCoordList    :: !(Vector Float)        -- ^ List of y atom coordinates in A, one for each atom [binary (type 10)]
                         , zCoordList    :: !(Vector Float)        -- ^ List of z atom coordinates in A, one for each atom [binary (type 10)]
                         , occupancyList :: !(Vector Float)        -- ^ List of atom occupancies, one for each atom [binary (type 9)]
                         }
  deriving (Show, Eq, Generic, NFData)

-- | MMTF datatype
--
data MMTF = MMTF { format    :: !FormatData    -- ^ MMTF format data
                 , structure :: !StructureData -- ^ Biological structure data
                 , model     :: !ModelData     -- ^ Models data
                 , chain     :: !ChainData     -- ^ Chains data
                 , group     :: !GroupData     -- ^ Groups data
                 , atom      :: !AtomData      -- ^ Atoms data
                 }
  deriving (Show, Eq, Generic, NFData)

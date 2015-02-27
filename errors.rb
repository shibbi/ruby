class BoundaryError < StandardError
end

class ExistingPieceError < StandardError
end

class NoPieceError < StandardError
end

class SameSpaceError < ArgumentError
end

class NoMoveError < StandardError
end

class InvalidMoveError < StandardError
end

class InputError < ArgumentError
end

class PlayerError < ArgumentError
end

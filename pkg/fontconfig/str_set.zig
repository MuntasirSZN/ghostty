const std = @import("std");
const c = @import("c.zig").c;

/// A set of strings owned by fontconfig's allocator. The strings added to
/// it are copied, so the caller's buffers can be freed afterwards.
pub const StrSet = opaque {
    pub fn create() *StrSet {
        return @ptrCast(c.FcStrSetCreate());
    }

    pub fn destroy(self: *StrSet) void {
        c.FcStrSetDestroy(@ptrCast(self));
    }

    pub fn add(self: *StrSet, s: [:0]const u8) bool {
        return c.FcStrSetAdd(@ptrCast(self), s.ptr) == c.FcTrue;
    }

    pub inline fn cval(self: *StrSet) *c.struct__FcStrSet {
        return @ptrCast(self);
    }
};

/// An iterator over a StrSet. Strings are borrowed from the set and remain
/// valid until the StrList is destroyed.
pub const StrList = opaque {
    pub fn create(set: *StrSet) ?*StrList {
        return @ptrCast(c.FcStrListCreate(set.cval()));
    }

    pub fn destroy(self: *StrList) void {
        c.FcStrListDone(@ptrCast(self));
    }

    /// Returns the first string in the set, or null if empty.
    pub fn first(self: *StrList) ?[:0]const u8 {
        const s = c.FcStrListFirst(@ptrCast(self));
        return if (s == null) null else std.mem.sliceTo(s, 0);
    }

    /// Returns the next string in the set, or null at the end.
    pub fn next(self: *StrList) ?[:0]const u8 {
        const s = c.FcStrListNext(@ptrCast(self));
        return if (s == null) null else std.mem.sliceTo(s, 0);
    }

    pub inline fn cval(self: *StrList) *c.struct__FcStrList {
        return @ptrCast(self);
    }
};

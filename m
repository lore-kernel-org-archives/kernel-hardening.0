MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
 <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
 <20190221052435.GF11758@eros.localdomain> <CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 21 Feb 2019 17:06:47 +0100
Message-ID: <CAG48ez0LjS5piXnx5924VbZQxEOwKeiAFmLEQChDNGAK65yfVg@mail.gmail.com>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 7:02 AM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Feb 20, 2019 at 9:25 PM Tobin C. Harding <me@tobin.cc> wrote:
> >
> > On Wed, Feb 20, 2019 at 05:05:10PM -0800, Kees Cook wrote:
> > > So, generally speaking, I'd love to split all strncpy* uses into
> > > strscpy_zero() (when expecting to do str->str copies), and some new
> > > function, named like mempadstr() or str2mem() that copies a str to a
> > > __nonstring char array, with trailing padding, if there is space. Then
> > > there is no more mixing the two cases and botching things.
>
> I should use "converts" instead of "copies" above, just to drive the
> point home. :)
>
> >
> > Oh cool, treewide changes, I'm down with that.  So to v2 I'll add
> > str2mem() and then attack the tree as suggested.  What could possibly go
> > wrong :)?
>
> Some clear documentation needs to be written for str2mem() to really
> help people understand what a "non string" character array is
> (especially given that it LOOKS like it has NUL termination -- when in
> fact it's just "padding").
>
> The tree-wide changes will likely take a while (and don't need to be
> part of this series unless you want to find a couple good examples)
> since we have to do them case-by-case: it's not always obvious when
> it's actually a non-string, so getting help from maintainers here will
> be needed. (And maybe some kind of flow chart added to
> Documentation/process/deprecated.rst for how to stop using strncpy()
> and strlcpy().)

Wild brainstorming ahead...

Such non-string character arrays are usually fixed-size, right? We
could use struct types around such character arrays to hide the actual
characters (so that people don't accidentally use them with C string
APIs), and enforce that the length is passed around as part of the
type... something like:

#define char_array(len) struct { char __ca_data[len]; }
#define __CA_UNWRAP(captr) (captr)->__ca_data, sizeof((captr)->__ca_data)

void __str2ca(char *dst, size_t dst_len, char *src) {
  size_t src_len = strlen(src);
  if (WARN_ON(src_len > dst_len)) {
    // or whatever else we think is the safest way to deal with this
    // without crashing, if BUG() is not an option.
    memset(dst, 0, dst_len);
    return;
  }
  memcpy(dst, src, src_len);
  memset(dst + src_len, 0, dst_len - src_len);
}
#define str2ca(dst, src) __str2ca(__CA_UNWRAP(dst), (src))

static inline void __ca2ca(char *dst, size_t dst_len, char *src,
size_t src_len) {
  BUILD_BUG_ON(dst_len < src_len);
  memcpy(dst, src, src_len);
  if (src_len != dst_len) {
    memset(dst + src_len, 0, dst_len - src_len);
  }
}
#define ca2ca(dst, src) __ca2ca(__CA_UNWRAP(dst), __CA_UNWRAP(src))


And if you want to do direct assignments instead of using helpers, you
make a typedef like this (since just assigning between two equivalent
structs doesn't work):

typedef char_array(20) blah_name;
blah_name global_name;
int main(int argc, char **argv) {
  blah_name local_name;
  str2ca(&local_name, argv[1]);
  global_name = local_name;
}

You'd also have to use a typedef like this if you want to pass
references to other functions.


Something like this would also be neat for classic C strings in some
situations - if you can put bounds in the types, or (if the string is
dynamically-sized) in the struct, you don't need to messily pass
around bounds for things like snprint() and so on.

> What I can't quite figure out yet is how to find a way for sfr to flag
> newly added users of strcpy, strncpy, and strlcpy. We might need to
> bring back __deprecated, but hide it behind a W=linux-next flag or
> something crazy. Stephen, in your builds you're already injecting
> -Wimplicit-fallthrough: do you do W=1 or anything like that? If not, I
> think we need some W= setting for your linux-next builds that generate
> the maintainer-nag warnings...
>
> -Kees
>
> P.S. Here's C string API Rant (I just had to get this out, please feel
> free to ignore):
>
> strcpy returns dest ... which is already known, so it's a meaningless
> return value.
>
> strncpy returns dest (still meaningless)

Weeeell... it kinda makes sense if you're trying to micro-optimize the
amount of stack spills. If you write code like this:

char *a = malloc(10);
a = strcpy(a, other_string);
return a;

... then the compiler doesn't have to shove `a` in one of the
callee-saved registers or spill it to the stack around the strcpy().
Plus, it might allow tail-call optimizations in some cases.

> strlcpy returns strlen(src) ... the length we WOULD have copied. Why
> would we care about that? I'm operating on dest. Were there callers
> that needed to both copy part of src and learn how long it was at the
> same time?

You could use it to optimistically attempt a copy in a fastpath, and
then fall back to a reallocation if that failed.

> strscpy returns -E2BIG or non-NUL bytes copied: yay, a return about
> what actually happened from the operation!
>
> ... snprintf returns what it WOULD have written, much like strlcpy
> above. At least snprintf has an excuse: it can be used to calculate an
> allocation size (called with a NULL dest and 0 size) ... but shouldn't
> "how big is this format string going to be?" be a separate function? I
> wonder if we can kill all kernel uses of snprintf too (after
> introducing a "how big would it be?" function and switching all other
> callers over to scnprintf)...
>
> So scnprintf() does the right thing (count of non-NUL bytes copied out).

That seems kinda suboptimal. Wouldn't you ideally want to bail out
with an error, or at least do a WARN(), if you're trying to format a
string that doesn't fit into its destination? Like, for example, if
you're assembling a path, and the path doesn't fit into a buffer, and
so you just use half of it, you might end up in a very different place
from where you intended to go.

> So now our safe(r?) string API versions use different letters to show
> they're safe: "s" in strcpy and "cn" in sprintf. /me cries forever.

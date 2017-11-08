Date: Wed, 8 Nov 2017 17:23:33 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20171108232333.oadyl6a6smaxnthp@treble>
References: <1509580240-28314-1-git-send-email-me@tobin.cc>
 <CAGXu5jLGLAWeQ28t3TiRswbfHM9F0odZia-f=-c5sVpYm+-0UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jLGLAWeQ28t3TiRswbfHM9F0odZia-f=-c5sVpYm+-0UA@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] vla: add VLA macro and testing
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, Nick Desaulniers <ndesaulniers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 08, 2017 at 02:58:19PM -0800, Kees Cook wrote:
> On Wed, Nov 1, 2017 at 4:50 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > Variable Length Arrays (VLA) pose a risk to the stack if the variable
> > passed into the array declaration is too large. If the variable used can
> > be controlled by a malicious party then this poses a security risk to
> > the kernel.
> >
> > Add a macro for declaring VLA's. Macro includes a requested size and a
> > maximum size, if requested size is larger than maximum size then
> > requested size is capped at maximum. Requested size is passed by
> > reference and updated by macro so caller has access to size of array
> > after declaration.
> >
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> >
> > ---
> >
> > I was unable to get the test module to integrate with the kernel build system
> > correctly. The attempt was to mirror the way `lib/test_printf.c` functions. This
> > effort was unsuccessful, it is included in the patch in the hope of getting
> > better suggestions. To test, the test module was built out of tree and all tests
> > pass.
> >
> > The macro needs some work. It functions as intended but
> >
> > Checkpatch emits ERROR: Macros with multiple statements should be enclosed in a
> > do - while loop.
> >
> > Also for each use of VLA() checkpatch emits WARNING: Missing a blank line after
> > declarations.
> >
> > Also I was unsure where to put the macro definition, appreciate any suggestions.
> 
> While I'd certainly like to see SOME kind of sanity checking for VLAs,
> my preference would be to entirely eliminate them at get -Werror=vla
> added to the Makefile. Even Linus has expressed irritation over the
> idea of VLAs in structs in the past:
> 
> https://lkml.org/lkml/2013/9/23/500
> 
> I imagine VLAs make Josh's life harder too. Would objtool have an
> easier time if there were no VLAs?

As it turns out, it doesn't make objtool's life that much harder.  GCC
sets up a frame pointer before doing the stack allocation anyway.

But, I strongly agree that VLAs should just go away.

-- 
Josh

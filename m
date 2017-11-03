Date: Sat, 4 Nov 2017 09:02:00 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171103220200.GK7499@eros>
References: <1509580240-28314-1-git-send-email-me@tobin.cc>
 <20171103084444.r7ls2klvwk7ndq7a@docker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103084444.r7ls2klvwk7ndq7a@docker>
Subject: Re: [kernel-hardening] [RFC] vla: add VLA macro and testing
To: Tycho Andersen <tycho@docker.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 03, 2017 at 11:44:44AM +0300, Tycho Andersen wrote:
> On Thu, Nov 02, 2017 at 10:50:40AM +1100, Tobin C. Harding wrote:
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
> > 
> > thanks,
> > Tobin.
> > 
> >  include/linux/vla.h                | 24 ++++++++++
> >  lib/Kconfig.debug                  |  3 ++
> >  lib/Makefile                       |  1 +
> >  lib/test_vla.c                     | 98 ++++++++++++++++++++++++++++++++++++++
> >  tools/testing/selftests/lib/config |  1 +
> >  5 files changed, 127 insertions(+)
> >  create mode 100644 include/linux/vla.h
> >  create mode 100644 lib/test_vla.c
> > 
> > diff --git a/include/linux/vla.h b/include/linux/vla.h
> > new file mode 100644
> > index 000000000000..e8f1572bbf42
> > --- /dev/null
> > +++ b/include/linux/vla.h
> > @@ -0,0 +1,24 @@
> > +/*
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +#ifndef __LINUX_VLA_H
> > +#define __LINUX_VLA_H
> > +
> > +/*
> > + * When declaring a local variable using VLA(), VLA() must be the last
> > + * declaration otherwise a compiler warning [-Wdeclaration-after-statement] will
> > + * be generated
> > + */
> > +#define VLA(type, name, size, max) \
> > +	type name[(*size < max ? *size : max)]; \
> > +	*size = (*size < max ? *size : max)
> 
> This requires you to have your VLAs at the end of the declarations,
> which is annoying and potentially limiting (limited to one VLA, etc.).
> I also don't think you need the pointer. Something like:
> 
> #define VLA(type, name, size, max) \
>         type name[(size < max ? max : (size = max))]
>
> should work I think.

         type name[(size < max ? size : (size = max))]

Oh, cool. Thanks Tycho. I'll test out your suggestion. At first glance I
think that will remove both the checkpatch issues and the declaration
annoyance. Nice one!

> It would also be nice to see some users of the VLA macro as part of
> this series.

Righto, I wondered if that was the done thing. Will add one for the next
spin.

thanks,
Tobin.

MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170724133824.27223-3-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com> <20170724133824.27223-3-LiljestrandH@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Jul 2017 19:40:57 -0700
Message-ID: <CAGXu5jLjZHjHj+kCU3qGzyc4RgjyFmDRJNrsxL_yhEz-qwqpXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 2/5] gcc-plugins: adds MPXK gcc plugin
To: Hans Liljestrand <liljestrandh@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
<liljestrandh@gmail.com> wrote:
> Adds a gcc-plugin that modifies vanilla GCC MPX instrumentation for
> in-kernel use. Also adds MPXK_CFLAGS Makefile variable that can be used to
> selectively enable MPXK for specific kernel objects. This plugin is not
> enabled kernel-wide and must be explicitly enabled in the appropriate
> Makefile.
>
> The purpose of the plugin is to replace BNDSTX+BNDLDX bound storage with
> our own mpxk_load_bounds function and to replace memory mainpulating
> function with corresponding wrapper function. The plugin accomplishes
> this via the following tasks:
>
> - It adds MPXK-wrappers functions for memory altering functions, e.g.
>   kmalloc, memcpy, etc. This is needed both to check bounds for input
>   argument pointers and properly set bounds for returned pointers. This
>   is done by the mpxk_wrappers compiler pass. (This could potentially
>   be done, for better performance, by direct instrumentation at the call
>   site.)
>
> - Replace BNDLDX calls with mpxk_load_bounds function calls. This
>   includes two separate cases: free-standing loads handled by the
>   mpxk_bnd_store pass, and loads in function prologues that are handled
>   by the mpxk_cfun_args pass. These are needed for situation where the
>   compile time instrumentation cannot determine a way to statically
>   propagate the bounds via the stack or registers.
>
> - The final mpxk_pass_sweeper removes any remaining BNDLDX/BNDSTX calls.

Since this creates multiple files for a single plugin, can you instead
relocate these into a subdirectory (which should be supported by the
build system already).

-Kees

-- 
Kees Cook
Pixel Security

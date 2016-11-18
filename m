Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 18 Nov 2016 11:42:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161118114234.GB1197@leverpostej>
References: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
 <20161116151611.GD11228@leverpostej>
 <CAGXu5jJ1LwLJ-f1Fx=Mu278-eeeqC+JakrH_WPT99PcHTXzbpA@mail.gmail.com>
 <20161118111059.GA1197@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118111059.GA1197@leverpostej>
Subject: Re: [kernel-hardening] patches for __write_rarely section
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 18, 2016 at 11:10:59AM +0000, Mark Rutland wrote:
> With something like the below (assuming all helpers are inlined):
> 
> #define rare_write(__var, __val) ({				\
> 	typeof(var) *__rw_var;					\

... iwith s/var/__var/ here...

> 	__some_typecheck_perhaps(__var, __val);			\
> 								\
> 	__rw_var = __rare_rw_ptr(&(__var));			\
> 								\
> 	__rare_rw_map();					\
> 	*__rw_var = (__val);					\
> 	__rare_rw_unmap();					\
> 								\
> 	__clobber_var_so_gcc_knows(__var);			\
> })

... and with explicit clobber gone, since __rare_rw_unmap would
presumably have to have a memory clobber anyway, just like the fixmap
code.

Thanks,
Mark.

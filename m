Message-ID: <1485448847.14852.2.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 26 Jan 2017 17:40:47 +0100
In-Reply-To: <20170125135410.GF27026@arm.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
	 <20170125135410.GF27026@arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack
 frame object validation
To: Will Deacon <will.deacon@arm.com>, kpark3469@gmail.com
Cc: kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, keescook@chromium.org, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae, takahiro.akashi@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Le mercredi 25 janvier 2017 à 13:54 +0000, Will Deacon a écrit :
> diff --git a/arch/arm64/include/asm/thread_info.h
> > b/arch/arm64/include/asm/thread_info.h
> > index 46c3b93..f610c44 100644
> > --- a/arch/arm64/include/asm/thread_info.h
> > +++ b/arch/arm64/include/asm/thread_info.h
> > @@ -68,7 +68,62 @@ struct thread_info {
> > +	const void *oldframe;
> > +	const void *callee_fp = NULL;
> > +	const void *caller_fp = NULL;
> > +
> > +	oldframe = __builtin_frame_address(1);
> > +	if (oldframe) {
> > +		callee_fp = __builtin_frame_address(2);
> > +		if (callee_fp)
> > +			caller_fp = __builtin_frame_address(3);
> > +	}
> > 
> Which compilers have you tested this with? The GCC folks don't
> guarantee a frame layout, and they have changed it in the past, so I
> suspect this is pretty fragile. In particularly, if
> __builtin_frame_address just points at the frame record, then I don't
> think you can make assumptions about the placement of local variables
> and arguments with respect to that.
> 

https://gcc.gnu.org/onlinedocs/gcc-6.3.0/gcc/Return-Address.html#index-
g_t_005f_005fbuiltin_005fframe_005faddress-3701

"Calling this function with a nonzero argument can have unpredictable 
 effects, including crashing the calling program. As a result, calls 
 that are considered unsafe are diagnosed when the -Wframe-address 
 option is in effect. Such calls should only be made in debugging 
 situations."

-- 
Yann Droneaud
OPTEYA

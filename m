MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1485448847.14852.2.camel@opteya.com>
References: <1485351983-13873-1-git-send-email-kpark3469@gmail.com>
 <20170125135410.GF27026@arm.com> <1485448847.14852.2.camel@opteya.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 26 Jan 2017 09:36:44 -0800
Message-ID: <CAGXu5jKgEketcC0jcxejw+Bmg0qUNUR7xtB8=CAstKpO-bdwfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH] arm64: usercopy: Implement stack
 frame object validation
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Will Deacon <will.deacon@arm.com>, Keun-O Park <kpark3469@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae, AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 26, 2017 at 8:40 AM, Yann Droneaud <ydroneaud@opteya.com> wrote=
:
> Hi,
>
> Le mercredi 25 janvier 2017 =C3=A0 13:54 +0000, Will Deacon a =C3=A9crit =
:
>> diff --git a/arch/arm64/include/asm/thread_info.h
>> > b/arch/arm64/include/asm/thread_info.h
>> > index 46c3b93..f610c44 100644
>> > --- a/arch/arm64/include/asm/thread_info.h
>> > +++ b/arch/arm64/include/asm/thread_info.h
>> > @@ -68,7 +68,62 @@ struct thread_info {
>> > +   const void *oldframe;
>> > +   const void *callee_fp =3D NULL;
>> > +   const void *caller_fp =3D NULL;
>> > +
>> > +   oldframe =3D __builtin_frame_address(1);
>> > +   if (oldframe) {
>> > +           callee_fp =3D __builtin_frame_address(2);
>> > +           if (callee_fp)
>> > +                   caller_fp =3D __builtin_frame_address(3);
>> > +   }
>> >
>> Which compilers have you tested this with? The GCC folks don't
>> guarantee a frame layout, and they have changed it in the past, so I
>> suspect this is pretty fragile. In particularly, if
>> __builtin_frame_address just points at the frame record, then I don't
>> think you can make assumptions about the placement of local variables
>> and arguments with respect to that.
>>
>
> https://gcc.gnu.org/onlinedocs/gcc-6.3.0/gcc/Return-Address.html#index-
> g_t_005f_005fbuiltin_005fframe_005faddress-3701
>
> "Calling this function with a nonzero argument can have unpredictable
>  effects, including crashing the calling program. As a result, calls
>  that are considered unsafe are diagnosed when the -Wframe-address
>  option is in effect. Such calls should only be made in debugging
>  situations."

It does work, though, and given the CONFIG_FRAME_POINTER check, I
think this is fine. The kernel explicitly disables -Wframe-address
since it gets used in a number of places.

-Kees

--=20
Kees Cook
Nexus Security

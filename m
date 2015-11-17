Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <564AE0C9.9040706@gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
	<CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
	<56496AB0.5070905@gmail.com>
	<CAGXu5jJLcJBjyA+2xMA63tCr_xg7xxEoLk=RHKXRXM7L23AD7Q@mail.gmail.com>
	<564AE0C9.9040706@gmail.com>
Date: Tue, 17 Nov 2015 09:30:21 -0800
Message-ID: <CAGXu5jK17eGgHnpP2CEvhH5BEOZ+1tKS4eSkLfXFL7VrG=r4pg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening]
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 17, 2015 at 12:09 AM, Daniel Micay <danielmicay@gmail.com> wrote:
>> AOSP isn't enough, and even if people did submit them there, I would
>> be one of the AOSP reviewers asking that they be upstreamed instead.
>> ;)
>
> Sure, but it's a way to proving to upstream that the features are useful
> and work well. For example, lets say x86 Android adopted the
> segmentation-based KERNEXEC/UDEREF. Lets say it actually shipped in the
> next version of Android. I am pretty sure Linus would change his
> attitude towards it. You're not going to convince him by words rather
> than actions though. Not that improving Linux on a dying architecture
> should be the priority, but it's a good example.

Right, that's absolutely a potential path to keep open. It's
effectively what happened to things like Binder. Each piece is going
to be a little different. UDEREF is (politically still) a hard sell on
x86, but arm now has CONFIG_CPU_SW_DOMAIN_PAN that covers a fair bit
of non-LPAE-arm UDEREF. (I await spender's flames now...)

So, the more we split out and test, the better. :)

-Kees

-- 
Kees Cook
Chrome OS Security

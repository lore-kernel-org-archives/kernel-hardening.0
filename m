Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <57090CDE.6080509@gmail.com>
References: <1460138602-85386-1-git-send-email-thgarnie@google.com>
	<57090CDE.6080509@gmail.com>
Date: Mon, 11 Apr 2016 12:08:57 -0700
Message-ID: <CAGXu5j+8JtzFQnYGJKi-eqbNfjUM3hmo+vAXjoP-rpkHuH_02g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2] mm: SLAB freelist randomization
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: lazytyped <lazytyped@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Apr 9, 2016 at 7:08 AM, lazytyped <lazytyped@gmail.com> wrote:
>
>
> On 4/8/16 11:03 AM, Thomas Garnier wrote:
>> For example this attack against SLUB (also applicable against SLAB)
>> would be affected:
>> https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow/
>
> would it?
>
> - allocate a ton of shmid_kernel until you get a fresh page
> - free one of such objects (here is where your randomization comes into
> play)
> - allocate the "vulnerable" object
> - trigger the overflow
> - start "freeing" the others - one will work
>
> This doesn't work only in the case in which you are the last object in
> the SLUB. So what you are achieving is a 1/(pagesize/sizeof_objects)
> chance of making the attack less reliable. But I can free yet another
> object and retry, if the previous overflow didn't kill me (simplest way
> to guarantee that is to not completely fill the newly allocated SLUB page).

All the randomization stuff is just a statistical defense, though it
would seem to raise the bar of exploitation. I'd love to get a solid
example for an exploit that this mitigation would interfere with,
though. Do you know of any that would fit better here?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

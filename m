Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+Qdmo__S5zO-xt=ZX-8ck3y0E6K2tFTB-d8dsub9wJkA@mail.gmail.com>
References: <CACXcFm=VuN+vETYsCo7hJ6j2A=xLEimt8MC_RWQw2czTChnigw@mail.gmail.com>
 <CAGXu5jKJQRojLR858ai+C85nqiusfDzOqfyBBfgGOseyMiHaOg@mail.gmail.com>
 <CACXcFmnZN9MWY_jSGeNjh02wkiuZ6ZYb3DmzxRTTt8bmTCD6Og@mail.gmail.com> <CAGXu5j+Qdmo__S5zO-xt=ZX-8ck3y0E6K2tFTB-d8dsub9wJkA@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Thu, 16 Jun 2016 23:42:55 -0400
Message-ID: <CACXcFmnpOmnMRY5EZajELisQq+45kYYcT=t0Z4D3Own4yXLxwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Initialising random(4)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> wrote:

>>> Right now, the
>>> latent_entropy plugin does some static initialization with build-time
>>> randomness, and then augments the pool with additional entropy during
>>> boot. How does yours differ?
>>
>> Mine initialises all pools at compile time, using data from
>> /dev/urandom on the development machine
>
> Cool. Based on my quick examination, I think the latent_entropy way of
> doing this is no less secure but is much easier to implement (it's
> just an attribute addition in the code). It looks like your version
> ends up with a lot of #ifdefs, etc, and targets a single collection of
> arrays.

The #ifdefs are just because this was an RFC test version so
I used a CONFIG variable to control whether my initialisation
was done. Turn it off & the pool arrays just get declared.

If the patch were accepted, no #ifdefs would be needed.

> I'm open to ways these two methods could work together, of course!

I have not looked closely at the latent-entropy plug in. One
option would be to use my stuff at build time and the
other at boot time.

There were other parts of my patch series intended to
help at boot time, but unlike the initialisation stuff they
were somewhat complex and part of an all-or-nothing
proposed rewrite of a large chunk of the driver. Also,
unlike the init stuff they would not apply to the current
driver because Ted has changed some things since
I did those patches.

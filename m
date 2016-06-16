Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKJQRojLR858ai+C85nqiusfDzOqfyBBfgGOseyMiHaOg@mail.gmail.com>
References: <CACXcFm=VuN+vETYsCo7hJ6j2A=xLEimt8MC_RWQw2czTChnigw@mail.gmail.com>
 <CAGXu5jKJQRojLR858ai+C85nqiusfDzOqfyBBfgGOseyMiHaOg@mail.gmail.com>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Thu, 16 Jun 2016 13:31:17 -0400
Message-ID: <CACXcFmnZN9MWY_jSGeNjh02wkiuZ6ZYb3DmzxRTTt8bmTCD6Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Initialising random(4)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 1:10 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jun 16, 2016 at 10:06 AM, Sandy Harris <sandyinchina@gmail.com> wrote:

>> The gresecurity patches include code to initiailse the driver's pools
>> with random data. I have different code to accomplish the same task &
>> think anyone planning to integrate that part of the gre stuff into the
>> kernel should also have a look at mine:
>> https://github.com/sandy-harris/random.gcm/blob/random_gcm/scripts/gen_random.c
>>
>> I submitted an earlier version as a kernel patch, part of a large &
>> complex series of proposed patches.
>
> Do you have a URL to the kernel patch you sent?

Create the program to initialise things:
https://lkml.org/lkml/2015/11/7/137

Changes to the driver to use it:
https://lkml.org/lkml/2015/11/7/133

> Right now, the
> latent_entropy plugin does some static initialization with build-time
> randomness, and then augments the pool with additional entropy during
> boot. How does yours differ?

Mine initialises all pools at compile time, using data from
/dev/urandom on the development machine

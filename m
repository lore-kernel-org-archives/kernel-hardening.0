Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CACXcFm=VuN+vETYsCo7hJ6j2A=xLEimt8MC_RWQw2czTChnigw@mail.gmail.com>
References: <CACXcFm=VuN+vETYsCo7hJ6j2A=xLEimt8MC_RWQw2czTChnigw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 16 Jun 2016 10:10:52 -0700
Message-ID: <CAGXu5jKJQRojLR858ai+C85nqiusfDzOqfyBBfgGOseyMiHaOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Initialising random(4)
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 10:06 AM, Sandy Harris <sandyinchina@gmail.com> wrote:
> The gresecurity patches include code to initiailse the driver's pools
> with random data. I have different code to accomplish the same task &
> think anyone planning to integrate that part of the gre stuff into the
> kernel should also have a look at mine:
> https://github.com/sandy-harris/random.gcm/blob/random_gcm/scripts/gen_random.c
>
> I submitted an earlier version as a kernel patch, part of a large &
> complex series of proposed patches.

Do you have a URL to the kernel patch you sent? Right now, the
latent_entropy plugin does some static initialization with build-time
randomness, and then augments the pool with additional entropy during
boot. How does yours differ?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

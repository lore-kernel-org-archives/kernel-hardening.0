Sender: Hans Liljestrand <ishkamiel@gmail.com>
Date: Tue, 25 Jul 2017 10:57:34 +0300
From: Hans Liljestrand <liljestrandh@gmail.com>
Message-ID: <20170725075734.3vnyt4awlftm3c4k@ishxps>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
 <20170724133824.27223-5-LiljestrandH@gmail.com>
 <CAGXu5jLk-LFGg4RW6_qGBXjgpvxySUh71Xod_C=JuqK4XmBAzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jLk-LFGg4RW6_qGBXjgpvxySUh71Xod_C=JuqK4XmBAzw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 4/5] x86: MPXK base
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 07:48:03PM -0700, Kees Cook wrote:
>On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
><liljestrandh@gmail.com> wrote:
>> Enable and add needed support functionality for ring 0 MPX. MPXK is
>> enabled in init/main.c by setting the BNDCFGS MSR registers. This also
>> includes the mpxk_load_bounds implementation and error handling code for
>> MPX errors, i.e. bound violations.
>
>Maybe I missed it somewhere else, but this seems like there is no CPU
>feature flag testing. I'd expect runtime alternatives or something to
>disable this dynamically if the CPU didn't support it.

No, it seems I missed it :)

(although I am sure I had a test in there at some point)

Thanks for catching this!

-hans

>
>-Kees
>
>-- 
>Kees Cook
>Pixel Security

MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170724133824.27223-5-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com> <20170724133824.27223-5-LiljestrandH@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Jul 2017 19:48:03 -0700
Message-ID: <CAGXu5jLk-LFGg4RW6_qGBXjgpvxySUh71Xod_C=JuqK4XmBAzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 4/5] x86: MPXK base
To: Hans Liljestrand <liljestrandh@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
<liljestrandh@gmail.com> wrote:
> Enable and add needed support functionality for ring 0 MPX. MPXK is
> enabled in init/main.c by setting the BNDCFGS MSR registers. This also
> includes the mpxk_load_bounds implementation and error handling code for
> MPX errors, i.e. bound violations.

Maybe I missed it somewhere else, but this seems like there is no CPU
feature flag testing. I'd expect runtime alternatives or something to
disable this dynamically if the CPU didn't support it.

-Kees

-- 
Kees Cook
Pixel Security

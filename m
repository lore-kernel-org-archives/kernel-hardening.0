Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
 <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com> <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 13:17:02 -0400
Message-ID: <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Shubham Bansal <illusionist.neo@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 12, 2016 at 9:25 AM, Shubham Bansal
<illusionist.neo@gmail.com> wrote:
> So overall I have 3 options :
>
> PaX's UDEREF feature - I want to work on this if its needed

This is a large project.

> PAN emulation on ARMv8.0 - My second preference would be this.

This sounds like it requires more research?

> Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do it if
> need

I think this has value and there are folks that can help direct you
through this. Since you're new to kernel development, maybe start here
to get a sense of the amount of work needed, and then go from there?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security

Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4F3DD84B.30808@zytor.com>
Date: Thu, 16 Feb 2012 20:32:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com> <4F3D766E.7040205@zytor.com> <CABqD9haWxRLac1w3m9rSmyDvcg8jxYcxdmAAsgB7pEEBMHr=2g@mail.gmail.com> <4F3D7DD4.6070103@zytor.com> <CABqD9hZd41AWZub+wxGWwxJtGWfk+pVWQhn7DM_0q0tS9r_wDA@mail.gmail.com> <1329439809.2337.32.camel@localhost> <CABqD9hY06gaA7T8f0Te9PFpip6ix7CcbRShWcXutxbivEZJ2og@mail.gmail.com> <4F3DD39C.9090905@zytor.com> <CABqD9haiko3xLUKFp_MZcd8G7Hsyif75ABk1HOVKNJ7=NZRRsA@mail.gmail.com>
In-Reply-To: <CABqD9haiko3xLUKFp_MZcd8G7Hsyif75ABk1HOVKNJ7=NZRRsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: Eric Paris <eparis@redhat.com>, Markus Gutschke <markus@chromium.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On 02/16/2012 08:26 PM, Will Drewry wrote:
>>
>> For x32 you have the option of introducing a new value or relying on bit
>> 30 in eax (and AUDIT_ARCH_X86_64).  The latter is more natural, probably.
> 
> Will that bit be visible as the syscall number or will it be stripped
> out before passing the number around?  If it's visible, then it
> doesn't seem like there'd need to be a new AUDIT_ARCH, but I suspect
> someone like Eric will have an actually useful opinion.
> 

Bit 30 is visible in orig_eax; whether you export it as part of "the
syscall number" is presumably TBD, but I think it's more natural to do so.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

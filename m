Date: Tue, 20 Jun 2017 12:20:41 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170620112040.GE28157@leverpostej>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
 <995f7cdd-9894-5daf-2910-c2aba980302c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <995f7cdd-9894-5daf-2910-c2aba980302c@redhat.com>
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add
 stackleak feature erasing the kernel stack at the end of syscalls
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>, ard.biesheuvel@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 13, 2017 at 02:51:59PM -0700, Laura Abbott wrote:
> On 06/09/2017 10:28 AM, Kees Cook wrote:
> > It seems like it shouldn't be too hard to add on-user-return erasure
> > code to other architectures too.
> 
> I played around getting this to compile for arm64 with a dummy
> stack clearing function. arm64 is doing something special with the
> efistub so it fails to link with
> 
> drivers/firmware/efi/libstub/arm-stub.c:45:(.init.text+0x54): relocation
> 	truncated to fit: R_AARCH64_CALL26 against undefined symbol `__efistub_track_stack'
> 
> The relocation to the .init.text section and appending __efistub happens after
> compilation so the checks in the plugin itself don't work. I haven't come up
> with a solution to not have the plugin run on the stub yet.

Can we do something like what we do for KCOV, and (only) place the
plugin-invoking flags to into CFLAGS_STACKLEAK, which we can filter out
in scripts/Makefile.lib?

Thanks,
Mark.

References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <995f7cdd-9894-5daf-2910-c2aba980302c@redhat.com>
Date: Tue, 13 Jun 2017 14:51:59 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add
 stackleak feature erasing the kernel stack at the end of syscalls
To: Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/09/2017 10:28 AM, Kees Cook wrote:
> It seems like it shouldn't be too hard to add on-user-return erasure
> code to other architectures too.

I played around getting this to compile for arm64 with a dummy
stack clearing function. arm64 is doing something special with the
efistub so it fails to link with

drivers/firmware/efi/libstub/arm-stub.c:45:(.init.text+0x54): relocation
	truncated to fit: R_AARCH64_CALL26 against undefined symbol `__efistub_track_stack'

The relocation to the .init.text section and appending __efistub happens after
compilation so the checks in the plugin itself don't work. I haven't come up
with a solution to not have the plugin run on the stub yet.

Thanks,
Laura

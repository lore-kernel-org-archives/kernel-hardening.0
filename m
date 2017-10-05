MIME-Version: 1.0
In-Reply-To: <1507157703-14972-1-git-send-email-alex.popov@linux.com>
References: <1507157703-14972-1-git-send-email-alex.popov@linux.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Oct 2017 21:40:48 -0700
Message-ID: <CALCETrWhzZF0St_=xVQvntcDt4Hc9qYkXZ6dyhK+NTAy7-dVEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v4 0/3] Introduce the STACKLEAK feature and a test for it
To: Alexander Popov <alex.popov@linux.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 3:55 PM, Alexander Popov <alex.popov@linux.com> wrote:
> This is the 4th version of the patch introducing STACKLEAK to the mainline
> kernel. STACKLEAK is a security feature developed by Grsecurity/PaX (kudos
> to them), which:

I'm working on some entry changes that could potentially interact with
this.  I'll try to get them out for review soon.

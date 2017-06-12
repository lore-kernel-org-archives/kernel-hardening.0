Date: Mon, 12 Jun 2017 19:32:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1497286620-15027-9-git-send-email-s.mesoraca16@gmail.com>
Message-ID: <alpine.DEB.2.20.1706121929430.1911@nanos>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com> <1497286620-15027-9-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 08/11] Creation of "pagefault_handler_x86" LSM hook
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 12 Jun 2017, Salvatore Mesoraca wrote:
> Creation of a new hook to let LSM modules handle user-space pagefaults on
> x86.
> It can be used to avoid segfaulting the originating process.
> If it's the case it can modify process registers before returning.

That explains, what you could do with it, but it completely lacks any
rationale WHY this is desired and good behaviour and how that is a security
feature.

Thanks,

	tglx

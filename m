Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1334267284-19166-15-git-send-email-wad@chromium.org>
References: <1334267284-19166-1-git-send-email-wad@chromium.org>
	<1334267284-19166-15-git-send-email-wad@chromium.org>
Date: Thu, 12 Apr 2012 15:11:50 -0700
Message-ID: <CAGXu5jLLoOqSS_zYehi1TbDXDPqitnAN1S401zgReRgEfUaTYw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v18 15/15] Documentation: prctl/seccomp_filter
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 12, 2012 at 2:48 PM, Will Drewry <wad@chromium.org> wrote:
> Documents how system call filtering using Berkeley Packet
> Filter programs works and how it may be used.
> Includes an example for x86 and a semi-generic
> example using a macro-based code generator.
>
> Acked-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Will Drewry <wad@chromium.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security

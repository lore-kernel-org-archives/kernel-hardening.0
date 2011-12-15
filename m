Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20111215064817.GB14237@elte.hu>
References: <20111215004311.GA11049@www.outflux.net>
	<20111215064817.GB14237@elte.hu>
Date: Wed, 14 Dec 2011 23:06:56 -0800
Message-ID: <CAGXu5jJ4enHVmrdsVK-gpE9RpXfjB7+s5+xRci6KQEhTGGed3g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2011.2] fs: symlink restrictions on sticky directories
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 14, 2011 at 10:48 PM, Ingo Molnar <mingo@elte.hu> wrote:

> * Kees Cook <keescook@chromium.org> wrote:
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 ab =3D audit_log_start(current->audit_context,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP=
_ATOMIC, AUDIT_AVC);
>
> Hm, is GFP_ATOMIC really necessary here? Why not GFP_KERNEL?
> This is in VFS process context, not in some atomic context that
> has to be careful about allocations, right?

Hm, that's true. I had started from the lsm_audit interface, but had
to expand it, and in the process copied its use of audit_log_start().
But yeah, I don't see a reason it can't be GFP_KERNEL. I'll adjust it.

Thanks!

-Kees

--=20
Kees Cook
ChromeOS Security

Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <4EDFAECF.9010407@xenotime.net>
References: <20111206235815.GA21764@www.outflux.net>
	<4EDFAECF.9010407@xenotime.net>
Date: Wed, 7 Dec 2011 10:26:32 -0800
Message-ID: <CAGXu5j+sfMLnH+j7Rhq=T-FN6ZMsznAybzAyCMDjw1kY-0PmDg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 7, 2011 at 10:22 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 12/06/2011 03:58 PM, Kees Cook wrote:
>> + =A0 =A0 =A0 Enabling this solves the problem by permitting symlinks to=
 only
>
> better:
>
> =A0 =A0 =A0 =A0 =A0Enabling this solves the problem by permitting symlink=
s to be followed
> =A0 =A0 =A0 =A0 =A0only when the uid ...
>
>> + * It will permit symlinks to only be followed when outside a sticky
>
> similar:
>
> =A0 =A0 =A0It will permit symlinks to be followed only when outside a sti=
cky

Thanks! I'll update these.

-Kees

--=20
Kees Cook
ChromeOS Security

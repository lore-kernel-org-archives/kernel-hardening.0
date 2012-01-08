Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120108114407.GA22056@parisc-linux.org>
References: <20120107185548.GA30748@outflux.net>
	<20120108114407.GA22056@parisc-linux.org>
Date: Sun, 8 Jan 2012 09:53:38 -0800
Message-ID: <CAGXu5j+ttzBowrrBNXYqtDaQ66C1GUD10dR0oVLiaDxwa5+X3g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 8, 2012 at 3:44 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Jan 07, 2012 at 10:55:48AM -0800, Kees Cook wrote:
>> v2012.2:
>> =A0- Change sysctl mode to 0600, suggested by Ingo Molnar.
>> =A0- Rework CONFIG logic to split code from default behavior.
>> =A0- Renamed sysctl to have a "sysctl_" prefix, suggested by Andrew Mort=
on.
>
> All the sysctl / CONFIG logic seems very complex. =A0Why not make it
> a module parameter instead? =A0It can be easily changed at boot time
> (specify kernel.insecure_symlinks=3D1 on the kernel command line) and,
> with a mode of 0600, can be modified at runtime too.

Well, I'll still need a CONFIG for the code itself, and the normal way
to tweak kernel operation is via sysctls, so I'd rather not switch to
cmdline options.

-Kees

--=20
Kees Cook
ChromeOS Security

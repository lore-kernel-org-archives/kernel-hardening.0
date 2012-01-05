Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120105143008.GA31728@elliptictech.com>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105143008.GA31728@elliptictech.com>
Date: Thu, 5 Jan 2012 11:34:43 -0800
Message-ID: <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2012 at 6:30 AM, Nick Bowler <nbowler@elliptictech.com> wrot=
e:
> On 2012-01-04 12:18 -0800, Kees Cook wrote:
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index 5f4c45d..26ede24 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -278,3 +278,19 @@ source "fs/nls/Kconfig"
>> =A0source "fs/dlm/Kconfig"
>>
>> =A0endmenu
>> +
>> +config PROTECTED_STICKY_SYMLINKS
>> + =A0 =A0 bool "Protect symlink following in sticky world-writable direc=
tories"
>> + =A0 =A0 default y
> [...]
>
> Why do we need a config option for this? =A0What's wrong with just using
> the sysctl?

This way the sysctl can configured directly without needing to have a
distro add a new item to sysctl.conf.

> Why have you made this option "default y", when enabling it clearly
> makes user-visible changes to kernel behaviour?

Ingo specifically asked me to make it "default y".

-Kees

--=20
Kees Cook
ChromeOS Security

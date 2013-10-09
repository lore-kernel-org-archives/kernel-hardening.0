Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5255D2FD.6050705@gmail.com>
Date: Thu, 10 Oct 2013 09:04:45 +1100
From: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
References: <5255D023.2030907@gmail.com> <1381356014.2050.28.camel@joe-AO722>
In-Reply-To: <1381356014.2050.28.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] vsprintf: Check real user/group id for %pK
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/10/13 09:00, Joe Perches wrote:
> On Thu, 2013-10-10 at 08:52 +1100, Ryan Mallon wrote:
>> Some setuid binaries will allow reading of files which have read
>> permission by the real user id. This is problematic with files which
>> use %pK because the file access permission is checked at open() time,
>> but the kptr_restrict setting is checked at read() time. If a setuid
>> binary opens a %pK file as an unprivileged user, and then elevates
>> permissions before reading the file, then kernel pointer values may be
>> leaked.
> 
> Please review the patch I sent you a little more.
> 
>> Fix this by adding a check that in addition to the current process
>> having CAP_SYSLOG, that effective user and group ids are equal to the
>> real ids. If a setuid binary reads the contents of a file which uses
>> %pK then the pointer values will be printed as NULL if the real user
>> is unprivileged.
> 
> []
> 
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
>> @@ -1312,11 +1313,37 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>>  				spec.field_width = default_width;
>>  			return string(buf, end, "pK-error", spec);
>>  		}
> 
> Move the interrupt tests and pK-error printk
> into case 1:
> 
> It's the only case where CAP_SYSLOG needs to be
> tested so it doesn't need to be above the switch.

Like I said, I think it is useful to do the pK-error check anyway. It is
checking for internal kernel bugs, since if 'pK-error' ever gets
printed, then some kernel code is doing the wrong thing. Therefore, I
think it is useful to print it always (I would argue it even makes sense
when kptr_restrict=0). I decided to just leave that part of the code alone.

~Ryan

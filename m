Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <5255D023.2030907@gmail.com> <1381356014.2050.28.camel@joe-AO722>
	<5255D2FD.6050705@gmail.com> <1381356861.2050.33.camel@joe-AO722>
	<5255D7D4.8050204@gmail.com> <1381358030.2050.36.camel@joe-AO722>
	<5255DBD8.30005@gmail.com> <1381360187.2050.44.camel@joe-AO722>
	<87pprck0q7.fsf@xmission.com> <52576E32.1050700@gmail.com>
Date: Thu, 10 Oct 2013 20:34:01 -0700
In-Reply-To: <52576E32.1050700@gmail.com> (Ryan Mallon's message of "Fri, 11
	Oct 2013 14:19:14 +1100")
Message-ID: <87txgoh45y.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Ryan Mallon <rmallon@gmail.com> writes:

> On 11/10/13 13:20, Eric W. Biederman wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>>> Some setuid binaries will allow reading of files which have read
>>> permission by the real user id. This is problematic with files which
>>> use %pK because the file access permission is checked at open() time,
>>> but the kptr_restrict setting is checked at read() time. If a setuid
>>> binary opens a %pK file as an unprivileged user, and then elevates
>>> permissions before reading the file, then kernel pointer values may be
>>> leaked.
>>>
>>> This happens for example with the setuid pppd application on Ubuntu
>>> 12.04:
>>>
>>>   $ head -1 /proc/kallsyms
>>>   00000000 T startup_32
>>>
>>>   $ pppd file /proc/kallsyms
>>>   pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
>>>
>>> This will only leak the pointer value from the first line, but other
>>> setuid binaries may leak more information.
>>>
>>> Fix this by adding a check that in addition to the current process
>>> having CAP_SYSLOG, that effective user and group ids are equal to the
>>> real ids. If a setuid binary reads the contents of a file which uses
>>> %pK then the pointer values will be printed as NULL if the real user
>>> is unprivileged.
>>>
>>> Update the sysctl documentation to reflect the changes, and also
>>> correct the documentation to state the kptr_restrict=0 is the default.
>> 
>> Sigh.  This is all wrong.  The only correct thing to test is
>> file->f_cred.  Aka the capabilities of the program that opened the
>> file.
>> 
>> Which means that the interface to %pK in the case of kptr_restrict is
>> broken as it has no way to be passed the information it needs to make
>> a sensible decision.
>
> Would it make sense to add a struct file * to struct seq_file and set
> that in seq_open? Then the capability check can be done against
> seq->file.

It would make most sense to do the capability check at open time,
and cache the result.  Doing it generically so that seq_printf could
still use %pK doesn't sound wrong, but it does sound convoluted.

Eric

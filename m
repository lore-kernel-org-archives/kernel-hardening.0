Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <525C56EF.8000807@gmail.com>
Date: Tue, 15 Oct 2013 07:41:19 +1100
From: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
References: <5255D023.2030907@gmail.com> <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com> <1381356861.2050.33.camel@joe-AO722> <5255D7D4.8050204@gmail.com> <1381358030.2050.36.camel@joe-AO722> <5255DBD8.30005@gmail.com> <1381360187.2050.44.camel@joe-AO722> <87pprck0q7.fsf@xmission.com> <52576E32.1050700@gmail.com> <20131014101706.GA5605@dztty>
In-Reply-To: <20131014101706.GA5605@dztty>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 14/10/13 21:17, Djalal Harouni wrote:

> On Fri, Oct 11, 2013 at 02:19:14PM +1100, Ryan Mallon wrote:
>> On 11/10/13 13:20, Eric W. Biederman wrote:
>>> Joe Perches <joe@perches.com> writes:
>>>
>>>> Some setuid binaries will allow reading of files which have read
>>>> permission by the real user id. This is problematic with files which
>>>> use %pK because the file access permission is checked at open() time,
>>>> but the kptr_restrict setting is checked at read() time. If a setuid
>>>> binary opens a %pK file as an unprivileged user, and then elevates
>>>> permissions before reading the file, then kernel pointer values may be
>>>> leaked.
>>>>
>>>> This happens for example with the setuid pppd application on Ubuntu
>>>> 12.04:
>>>>
>>>>   $ head -1 /proc/kallsyms
>>>>   00000000 T startup_32
>>>>
>>>>   $ pppd file /proc/kallsyms
>>>>   pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
>>>>
>>>> This will only leak the pointer value from the first line, but other
>>>> setuid binaries may leak more information.
>>>>
>>>> Fix this by adding a check that in addition to the current process
>>>> having CAP_SYSLOG, that effective user and group ids are equal to the
>>>> real ids. If a setuid binary reads the contents of a file which uses
>>>> %pK then the pointer values will be printed as NULL if the real user
>>>> is unprivileged.
>>>>
>>>> Update the sysctl documentation to reflect the changes, and also
>>>> correct the documentation to state the kptr_restrict=0 is the default.
>>>
>>> Sigh.  This is all wrong.  The only correct thing to test is
>>> file->f_cred.  Aka the capabilities of the program that opened the
>>> file.
>>>
>>> Which means that the interface to %pK in the case of kptr_restrict is
>>> broken as it has no way to be passed the information it needs to make
>>> a sensible decision.
>>
>> Would it make sense to add a struct file * to struct seq_file and set
>> that in seq_open? Then the capability check can be done against seq->file.
> For the "add a struct file * to struct seq_file" and set it during
> seq_open(), It was proposed by Linus, but Al Viro didn't like it:
> https://lkml.org/lkml/2013/9/25/765
> 
> I'm not sure if this will work for you: you can make seq_file->private
> cache some data, by calling single_open()... at ->open(), later check it
> during read()...
> 
> 
> As noted by Eric, I'll also go for the capability check at ->open(), if it
> does not break some userspace. BTW the CAP_SYSLOG check should do the job

Yes, it has already been agreed on that open() time is the correct place to
do the check, and that either the check value should be cached in the
struct seq_file or the struct cred/file should be kept so that the check
can be done later. I think caching the result is actually better since it
removes the whole in_irq() problem also.

The problem I have at the moment is handling the case for 
/sys/module<modname>/sections/*, which are seq_files in Greg's
driver-core tree, but do not actually pass the struct seq_file to the show
function, which makes it impossible to check what the open() time
permissions were.

> Checks during read() are not sufficient, since the design allows passing
> file descriptors and dup() stdin/stdout of suid-execve.
> 
> 
> IMO: unprivileged code should not get that file descriptor, so ->open()
> should fail.
> If this will break userspace then allow open() and cache result for read()
> 
> 
> Can you emulate the behaviour of kptr_restrict=1 ? If so:
> 1) perform check during open() and cache data
> 2) during read() check kptr_restrict==1
>    check the cached value and if opener had CAP_SYSLOG  if so:
>    print something like this: 00000000 T startup_32
> 
> All this without modifying vsprintf, I mean just do the checks outside
> vsprintf() inside your ->read()


Again, this has already been agreed on. As suggested by George I have
a function called seq_kernel_pointer(), which returns either the real
pointer or NULL based on the cached check at seq_open(), so you do
prints like:

  seq_printf(seq, "secret value = %p\n", seq_kernel_pointer(seq, ptr));

Once I figure out how to resolve the module sections case, I will post
a patch series.

~Ryan

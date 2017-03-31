MIME-Version: 1.0
In-Reply-To: <CALCETrWooKTtViVh4ik9e-3nLs3NET9wptgxhjS9V499sfUJQA@mail.gmail.com>
References: <1490887379-25880-1-git-send-email-tixxdz@gmail.com> <CALCETrWooKTtViVh4ik9e-3nLs3NET9wptgxhjS9V499sfUJQA@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Fri, 31 Mar 2017 13:45:54 +0200
Message-ID: <CAEiveUdtJ5WojbqsXhfq2bS8ZN3zMzr2o8zXf1aO26ZaPBNuzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH RFC 0/4] proc: support multiple separate proc instances
 per pidnamespace
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Kees Cook <keescook@chromium.org>, Dongsu Park <dpark@posteo.net>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 30, 2017 at 9:12 PM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
> On Thu, Mar 30, 2017 at 8:22 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> Hi,
>>
>> This RFC can be applied on top of Linus' tree 89970a04d7
>>
>> This RFC implements support for multiple separate proc instances inside
>> the same pid namespace. This allows to solve lot of problems that
>> today's use case face.
>>
>> Historically procfs was tied to pid namespaces, and mount options were
>> propagated to all other procfs instances in the same pid namespace. This
>> solved several use cases in that time. However today we face new
>> problems, there are mutliple container implementations there, some of
>> them want to hide pid entries, others want to hide non-pid entries,
>> others want to have sysctlfs, others want to share pid namespace with
>> private procfs mounts. All these with current implementation won't work
>> since all options will be propagated to all procfs mounts.
>>
>> This series allow to have new instances of procfs per pid namespace wher=
e
>> each instance can have its own mount option inside the same pid namespac=
e.
>> This was also suggested by Andy Lutomirski.
>>
>>
>> Now:
>> $ sudo mount -t proc -o unshare,hidepid=3D2 none /test
>>
>> The option 'unshare' will allow to mount a new instance of procfs inside
>> the same pid namespace.
>>
>> Before:
>> $ stat /proc/slabinfo
>>
>>   File: =E2=80=98/proc/slabinfo=E2=80=99
>>   Size: 0               Blocks: 0          IO Block: 1024   regular empt=
y file
>> Device: 4h/4d   Inode: 4026532046  Links: 1
>>
>> $ stat /test3/slabinfo
>>
>>   File: =E2=80=98/test3/slabinfo=E2=80=99
>>   Size: 0               Blocks: 0          IO Block: 1024   regular empt=
y file
>> Device: 4h/4d   Inode: 4026532046  Links: 1
>>
>>
>> After:
>> $ stat /proc/slabinfo
>>
>>   File: =E2=80=98/proc/slabinfo=E2=80=99
>>   Size: 0               Blocks: 0          IO Block: 1024   regular empt=
y file
>> Device: 4h/4d   Inode: 4026532046  Links: 1
>>
>> $ stat /test3/slabinfo
>>
>>   File: =E2=80=98/test3/slabinfo=E2=80=99
>>   Size: 0               Blocks: 0          IO Block: 1024   regular empt=
y file
>> Device: 31h/49d Inode: 4026532046  Links: 1
>>
>>
>> Any better name for the option 'unshare' ? suggestions ?
>>
>> I was going to use 'version=3D2' but then this may sound more like a
>> proc2 fs which currently impossible to implement since it will share
>> locks with the old proc.
>>
>>
>> Al, Eric any comments please ?
>
> I like the concept, except that I think it would be nice to avoid
> needing 'unshare', perhaps by making unsharing the default and making
> hidepid work backwards compatibly if needed.

Of course I can update, but as said lot of stuff may already depend on
the behaviour of procfs mount options, and the device ID inside same
pid namespace where is it is always the same ID. With this change we
will have different IDs inside same pid namespace, and I don't have
the knowledge to predict if something will break. I remember you said
that we may update stat() to show same ID but I really don't know if
that's a good idea, what if userspace now tries to check if these are
two separate proc mounts ? also maybe there is third party kernel code
that does something with these device IDs ?

For the namespace introspection, Eric suggested that we may stat /proc
before stating /proc/pid/ns/x , however he also concluded that some
security or other obscure stuff may break! I basically don't have the
resources nor the knowledge to predict what errors may come due to
changing the default behaviour of procfs. From my position it is
better to introduce a new option for it so users are warned. Is this
reasonable ? or do we have to make it default ?

Thanks!

--=20
tixxdz

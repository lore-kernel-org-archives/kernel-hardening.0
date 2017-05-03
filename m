MIME-Version: 1.0
In-Reply-To: <CALCETrV4SjQE_NM4=j0JgRGBjOVY4o=iu0=ruuvzSuGRUPgNbg@mail.gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
 <1493123038-30590-5-git-send-email-tixxdz@gmail.com> <CALCETrWOjLnfCgpAJs6tTjLXeNHjqPQa5qSZpztcnbR2kN5A2w@mail.gmail.com>
 <CAEiveUf22RQ6awvCKJ4p5OxZCPAyhOfpLBQXFLJ=tev3zDfL+g@mail.gmail.com> <CALCETrV4SjQE_NM4=j0JgRGBjOVY4o=iu0=ruuvzSuGRUPgNbg@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Wed, 3 May 2017 17:18:42 +0200
Message-ID: <CAEiveUfs4n1xU+5c_c-cz9FY1_JDi1_0jQAcYycnwqm6TM5ddA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH RFC v2 4/6] proc: support mounting private procfs
 instances inside same pid namespace
To: Andy Lutomirski <luto@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 2, 2017 at 6:33 PM, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, May 2, 2017 at 7:29 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> On Thu, Apr 27, 2017 at 12:13 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On Tue, Apr 25, 2017 at 5:23 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> [...]
>>>> We have to align procfs and modernize it to have a per mount context
>>>> where at least the mount option do not propagate to all other mounts,
>>>> then maybe we can continue to implement new features. One example is to
>>>> require CAP_SYS_ADMIN in the init user namespace on some /proc/* which are
>>>> not pids and which are are not virtualized by design, or CAP_NET_ADMIN
>>>> inside userns on the net bits that are virtualized, etc.
>>>> These mount options won't propagate to previous mounts, and the system
>>>> will continue to be usable.
>>>>
>>>> Ths patch introduces the new 'limit_pids' mount option as it was also
>>>> suggesed by Andy Lutomirski [1]. When this option is passed we
>>>> automatically create a private procfs instance. This is not the default
>>>> behaviour since we do not want to break userspace and we do not want to
>>>> provide different devices IDs by default, please see [1] for why.
>>>
>>> I think that calling the option to make a separate instance
>>> "limit_pids" is extremely counterintuitive.
>>
>> Ok.
>>
>>> My strong preference would be to make proc *always* make a separate
>>> instance (unless it's a bind mount) and to make it work.  If that
>>> means fudging stat() output, so be it.
>>
>> I also agree, but as said if we change stat(), userspace won't be able
>> to notice if these two proc instances are really separated, the device
>> ID is the only indication here.
>
> I re-read all the threads and I'm still not convinced I see why we
> need new_instance to be non-default.  It's true that the device
> numbers of /proc/ns/* matter, but if you look (with stat -L, for
> example), they're *already* not tied to the procfs instance.

Hmm, indeed, so the namespace FDs point internally to the internal
proc mount that is created during pidns initialization, this means
NS_GET_PARENT ioctl won't change which is good, only things that
relate on stat()ing other inodes may notice.


>
> I'm okay with adding new_instance to be on the safe side, but I'd like
> it to be done in a way that we could make it become the default some
> day without breaking anything.  This means that we need to be rather
> careful about how new_instance and hidepid interact.

Sounds good, from the devpts history it seems that "newinstance" was
used to absorb new changes/updates easily, and it was made a no-op
only recently with commit eedf265aa003b4 "devpts: Make each mount of
devpts an independent filesystem."  last year, where the initial
introduction was via commit 2a1b2dc0c83bbfc24 "Enable multiple
instances of devpts"  in 2009

Starting from this: 1) "hidepid" works withe the "gid" membership
option which is sticky, I would like to avoid this combination, plus
2) "hidepid" now changes the pid namespace option.

With "newinstance" set:

* "hidepid" instead of changing the pid namespace options, it will
only affect the new procfs instance.

* Changing "hidepid" value during a remount of a *private* procfs
instance will only affect that procfs instance and not the pid
namespace or the other shared procfs mounts.

* "pids=ptraceable" makes /proc/ show only pids that the caller can
ptrace. Together with NO_NEW_PRIVS set, it makes a good privacy
measure.
"pids=ptraceable" is also for *LSM* so we guarantee that there is a
ptrace security hook there for LSMs and that there are no relations or
exceptions between "pids=ptraceable" and "hidepid" / "gid" mount
options. This will benefit Yama LSM later.

* "pids=ptraceable" will take precedence over "hidepid"


I assume defaulting later to new instances should continue to work, comments ?


Thanks!

-- 
tixxdz

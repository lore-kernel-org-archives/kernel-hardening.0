MIME-Version: 1.0
In-Reply-To: <201702061949.HGE43791.FFFtJVSHQOOLOM@I-love.SAKURA.ne.jp>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com>
 <1486055094-4532-2-git-send-email-djalal@gmail.com> <201702061949.HGE43791.FFFtJVSHQOOLOM@I-love.SAKURA.ne.jp>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 6 Feb 2017 13:40:46 +0100
Message-ID: <CAEiveUdEsRGkMAoyyoDK52qUQbv5MfgKRA72T4X-qiQ4e-BhHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC/PATCH 1/3] security: add the security_task_copy() hook
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tetsuo,

On Mon, Feb 6, 2017 at 11:49 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Djalal Harouni wrote:
>> To achieve the above we add the security_task_copy() hook that allows us
>> to clone the Timgad context of parent into child task_struct.
>>
>> The security hook can also be used by new LSMs after the child task has
>> done some initialization, this way they won't clash with the major LSMs.
>> The situation is not really well, this hook allows us to introduce a
>> stackable LSM that can be easily used with all other LSMs.
>
> We are already planning to revive security_task_alloc() hook (probably in Linux 4.12)
> ( news://news.gmane.org:119/201701101958.JAD43709.OtJSOQFVFOLHMF@I-love.SAKURA.ne.jp ).
> Is security_task_alloc() called too early for your case?

Hmm, didn't know about it, thank you!

Yes that seems the same, to have a per-task vars or context.

I'm reading http://www.spinics.net/linux/fedora/linux-security-module/msg17004.html

For my specific use case I'm still not sure. I was thinking that since
this is LSM maybe it would be useful to only add one hook after all
the copy_*() functions that also copy the context, maybe another LSM
will find it useful and may want to check the context of namespaces,
fs (copy_namespaces(), copy_fs() ...). I mean this already happened to
me with security_task_create() which is too early, so maybe try to do
it right.

The other thing is cgroups cgroup_can_fork() better do it after which
avoids me to clean up. IMHO the best place is near or after
copy_seccomp() where we hold the lock, especially if there is an LSM
that wants to copy/apply the context on all other threads not only
current. Ultimately if we are copying stuff then maybe it should
happen as late as possible, and if we have to sleep I guess we can use
security_task_create() to allocate ?

What do you think ?

Thanks!

> (Well, we want to configure http archive like marc.info ?)



-- 
tixxdz

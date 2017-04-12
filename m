MIME-Version: 1.0
In-Reply-To: <8551d1ff-2c6e-bf9b-5615-fbff089ef252@schaufler-ca.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com> <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
 <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com> <CAEiveUd4Obc+YsCiO7dp3-jypbJ4vMmsBOU=Ax8yF7+6dLes0w@mail.gmail.com>
 <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com> <8551d1ff-2c6e-bf9b-5615-fbff089ef252@schaufler-ca.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Wed, 12 Apr 2017 18:08:45 +0200
Message-ID: <CAEiveUd+5NkW6Sfx1VSHqYCBUuB9rM4bF0yPBQZZXGe=EFCz6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/3] LSM: Allow per LSM
 module per "struct task_struct" blob.
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 11, 2017 at 9:54 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 4/10/2017 9:43 PM, Kees Cook wrote:
>> On Mon, Apr 10, 2017 at 1:00 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>>> On Mon, Apr 10, 2017 at 9:26 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> I think that would be the prudent approach. There is still
>>>> the possibility that blob sharing (or full stacking, if you
>>>> prefer) won't be accepted any time soon.
>>> Ok Casey! I will wait for more feedback, and if other maintainers do
>>> not object, I will convert it back to rhashtables in next iterations
>>> making sure that it should be simple to convert later to a blob
>>> sharing mechanism.
>> Would it be possible just to add a single field to task_struct if this
>> LSM is built in? I feel like rhashtables is a huge overhead when a
>> single field is all that's needed.
>
> Special casing the task_struct based on which modules
> are compiled in would work, but I'm under the impression
> that there's a strong desire to keep to one pointer for
> security module information in the major structures.
>
> The code for generalizing shared blobs isn't that hard,
> and y'all have seen it many times. It would be perfectly
> safe to convert the task, cred, inode and such blobs to
> be infrastructure managed right now. That wouldn't mean
> that all the stacking issues (e.g. audit and networking)
> would be addressed, or that all combinations of modules
> would work (i.e. no SELinux+Smack) but it would clear
> the way for this case. And Yama could use a blob if it
> wanted to.

I've been thinking about this again, so my patches did not convert
creds, inodes etc, I don't have a use case for them now. My use case
was for task->security and I re-used the simple approach. I can't
offer a solution for other blobs since I'm not familiar with their
context nor the different use cases. I checked TOMOYO and that was
easy, but I can't check all of them. I agreed that I may use
rhashtables but as Kees pointed out this may introduce overheads and
extra memory, where the task->security for this ModAutoProtect LSM
will only require an extra sizeof(unsigned long) per-task. Also again
the problem is not in this proposed Module, the problem is in modules
that can't be stacked together.

I am bringing this, since maybe after we manage to merge this, and if
Kees agree I may send another set of patches for Yama to enable the
same per-task context, this enables containers but also allows later
in systemd-logind sessions to set it where all inferiors inside the
user sessions are protected by default, not only some apps or special
desktops but for all. So I will hit the same problem again where to
put it? You said that the code that generalize the blobs isn't that
hard, but also in a previous response that it may not be accepted...
so I will try to converge the task->security blob to be more like the
infrastructure that you are proposing, then resubmit and maybe we will
enable these modules that are stackable by default.

Is this reasonable ?


Thanks!

-- 
tixxdz

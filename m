References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com>
 <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
 <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com>
 <CAEiveUd4Obc+YsCiO7dp3-jypbJ4vMmsBOU=Ax8yF7+6dLes0w@mail.gmail.com>
 <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <8551d1ff-2c6e-bf9b-5615-fbff089ef252@schaufler-ca.com>
Date: Tue, 11 Apr 2017 12:54:04 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/3] LSM: Allow per LSM
 module per "struct task_struct" blob.
To: Kees Cook <keescook@chromium.org>, Djalal Harouni <tixxdz@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 4/10/2017 9:43 PM, Kees Cook wrote:
> On Mon, Apr 10, 2017 at 1:00 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> On Mon, Apr 10, 2017 at 9:26 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> I think that would be the prudent approach. There is still
>>> the possibility that blob sharing (or full stacking, if you
>>> prefer) won't be accepted any time soon.
>> Ok Casey! I will wait for more feedback, and if other maintainers do
>> not object, I will convert it back to rhashtables in next iterations
>> making sure that it should be simple to convert later to a blob
>> sharing mechanism.
> Would it be possible just to add a single field to task_struct if this
> LSM is built in? I feel like rhashtables is a huge overhead when a
> single field is all that's needed.

Special casing the task_struct based on which modules
are compiled in would work, but I'm under the impression
that there's a strong desire to keep to one pointer for
security module information in the major structures.

The code for generalizing shared blobs isn't that hard,
and y'all have seen it many times. It would be perfectly
safe to convert the task, cred, inode and such blobs to
be infrastructure managed right now. That wouldn't mean
that all the stacking issues (e.g. audit and networking)
would be addressed, or that all combinations of modules
would work (i.e. no SELinux+Smack) but it would clear
the way for this case. And Yama could use a blob if it
wanted to.

>
> -Kees
>

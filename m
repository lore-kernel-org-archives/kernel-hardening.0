MIME-Version: 1.0
In-Reply-To: <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com> <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com>
 <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com> <CAEiveUd4Obc+YsCiO7dp3-jypbJ4vMmsBOU=Ax8yF7+6dLes0w@mail.gmail.com>
 <CAGXu5jL7jLid57UoXCxSqo5JZRLMgZ7X6BSYgWLckp5YpoiAmA@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Wed, 12 Apr 2017 18:22:01 +0200
Message-ID: <CAEiveUe=QWr3-K4gPH602MNz4XNr2FL3mRqzYfKo5C-g=-ZSBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/3] LSM: Allow per LSM
 module per "struct task_struct" blob.
To: Kees Cook <keescook@chromium.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 11, 2017 at 6:43 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Apr 10, 2017 at 1:00 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> On Mon, Apr 10, 2017 at 9:26 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> I think that would be the prudent approach. There is still
>>> the possibility that blob sharing (or full stacking, if you
>>> prefer) won't be accepted any time soon.
>>
>> Ok Casey! I will wait for more feedback, and if other maintainers do
>> not object, I will convert it back to rhashtables in next iterations
>> making sure that it should be simple to convert later to a blob
>> sharing mechanism.
>
> Would it be possible just to add a single field to task_struct if this
> LSM is built in? I feel like rhashtables is a huge overhead when a
> single field is all that's needed.

Well, yes rhashtables can have an overhead especially when reclaiming
memory back, I could not identify a way how to separate tables unless
we use cgroups as an ID. Anyway this of course could be added in
task_struct and updated to work like the capability security hooks
rather than a proper LSM with its own name. But as noted in the other
response, we may need task->security field for Yama anyway. I'm open
to suggestion ? I may try to converge the task->security blob with
what Casey is proposing and see! otherwise fallback to task_struct as
a last resort!

Thanks!

-- 
tixxdz

MIME-Version: 1.0
In-Reply-To: <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-2-git-send-email-tixxdz@gmail.com> <f25edeb6-35e1-2f8c-8fd6-fd051c4e79ce@schaufler-ca.com>
 <CAEiveUeHedQAsjbS5Jj9imq28af0OuKAjMTudMJm7GqObRNMfQ@mail.gmail.com> <2698e97b-397e-0fc0-84a1-dc9a4226117a@schaufler-ca.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 10 Apr 2017 22:00:00 +0200
Message-ID: <CAEiveUd4Obc+YsCiO7dp3-jypbJ4vMmsBOU=Ax8yF7+6dLes0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH RFC v2 1/3] LSM: Allow per LSM module per "struct
 task_struct" blob.
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 10, 2017 at 9:26 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 4/10/2017 11:30 AM, Djalal Harouni wrote:
>> On Mon, Apr 10, 2017 at 5:50 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> On 4/9/2017 3:42 AM, Djalal Harouni wrote:
>>>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
[...]

>>> While I appreciate your enthusiasm, I would really like
>>> to see a mechanism for managing all of the blobs as being
>>> potentially shared rather than just the task blob. With
>>> infrastructure blob management being the general case we
>>> could stack any set of existing modules that does not
>>> include both SELinux and Smack. (AppArmor is threatening
>>> to join that set, but we're still waiting on that) I
>> Yes! most of the other kernel maintainers I discussed the feature with
>> did not even believe or knew that LSM stacking is possible! Some other
>> kernel frameworks are being replaced with new ones (I'm not sure if
>> the old ones were perfect!)... but what I'm trying to say is that we
>> should make it easy for dynamic LSM plugins model so they can explore
>> the interface, and maybe after some time the whole framework will even
>> be replaced with a better one...
>
> I'm not committing to dynamic modules, but I am working
> to make sure I don't do anything to prevent someone else
> from doing it in the future. There are a good number of
> people who find the notion of dynamic security policy
> disturbing.

I understand, though that with today's container recycling use cases
some of it may make sense. Anyway you are doing the real work, you
know better.


>> Thanks to your effort and others we may achieve it, but I don't think
>> that delaying features for a perfect implementation is the best way.
>> During linuxcon 2016 Europe you said that there should be a new kind
>> of LSMs, that's why I think we should make it easy for that to happen.
>
> I agree that it's better to use a work-around today then to
> let the shortcomings of the existing infrastructure stop you
> from getting your job done.

Indeed!


>>
>>> think it's a bad idea to go ahead with one implementation
>>> for task blobs without taking care of the others.
>> Ok. Sorry if I missed this, but could you please point me why this
>> could be a bad idea ?
>
> It's a whole lot easier to maintain one sort of blob
> management then a different kind for each blob. It would
> be lots cleaner to have a single call that tells the
> infrastructure how much space you need for all your blobs
> than a separate interface for each.

I perfectly agree here. With Tetsuo patch it was easy to add a
stackable LSM, with a consistent approach that would be even better.
But as you note that should not be a blocker to upstream new stackable
LSMs.


>> As I understand it, these are internal details that could be replaced.
>> My first implementation used resizable concurrent hashtables that are
>> heavily used in the networking code and it worked, and I easily
>> converted the module to use Tetsuo's approach since I didn't see any
>> objection for it, and it continued to work. Maybe the point should be
>> *which* LSM should use the task->security and how ? The
>> ModAutoRestrict module is a simple LSM which could easily work with
>> any provided solution.
>
> So I see.
>
>> That being said, I could convert the module back and stick with
>> rhashtables for now since it does not conflict with any module and it
>> works well. I would like to avoid same history where Apparmor, Smack
>> and TOMOYO all suffered to get mainlined, even Yama due to some
>> requests...  Then I can convert the module back to use the same LSM
>> infrastructure if you maintainers think that how it should go, that's
>> totally fine by me. Yama internally could use the same task blob but
>> it is avoiding conflicts by using lists to manage its internal data,
>> that's the same design with ModAutoRestrict and rhashtables.
>
> I think that would be the prudent approach. There is still
> the possibility that blob sharing (or full stacking, if you
> prefer) won't be accepted any time soon.

Ok Casey! I will wait for more feedback, and if other maintainers do
not object, I will convert it back to rhashtables in next iterations
making sure that it should be simple to convert later to a blob
sharing mechanism.

Thanks again for the comments!


-- 
tixxdz

Return-Path: <SRS0=4sGs=IV=lists.openwall.com=kernel-hardening-return-21034-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A06C433E5
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Mar 2021 15:55:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F317F619D1
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Mar 2021 15:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F317F619D1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21034-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23594 invoked by uid 550); 23 Mar 2021 15:55:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23573 invoked from network); 23 Mar 2021 15:55:02 -0000
Subject: Re: [PATCH v30 07/12] landlock: Support filesystem access-control
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger
 <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-8-mic@digikod.net>
 <CAG48ez1arKO3uYzwng8fst-UHkcH6J7YzyHFN+vfXUT2=1HT+w@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <b41a021c-69f4-075f-e9a0-a4483b280df8@digikod.net>
Date: Tue, 23 Mar 2021 16:55:20 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez1arKO3uYzwng8fst-UHkcH6J7YzyHFN+vfXUT2=1HT+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 23/03/2021 01:13, Jann Horn wrote:
>  On Tue, Mar 16, 2021 at 9:43 PM Mickaël Salaün <mic@digikod.net> wrote:
>> Using Landlock objects and ruleset, it is possible to tag inodes
>> according to a process's domain.
> [...]
>> +static void release_inode(struct landlock_object *const object)
>> +       __releases(object->lock)
>> +{
>> +       struct inode *const inode = object->underobj;
>> +       struct super_block *sb;
>> +
>> +       if (!inode) {
>> +               spin_unlock(&object->lock);
>> +               return;
>> +       }
>> +
>> +       /*
>> +        * Protects against concurrent use by hook_sb_delete() of the reference
>> +        * to the underlying inode.
>> +        */
>> +       object->underobj = NULL;
>> +       /*
>> +        * Makes sure that if the filesystem is concurrently unmounted,
>> +        * hook_sb_delete() will wait for us to finish iput().
>> +        */
>> +       sb = inode->i_sb;
>> +       atomic_long_inc(&landlock_superblock(sb)->inode_refs);
>> +       spin_unlock(&object->lock);
>> +       /*
>> +        * Because object->underobj was not NULL, hook_sb_delete() and
>> +        * get_inode_object() guarantee that it is safe to reset
>> +        * landlock_inode(inode)->object while it is not NULL.  It is therefore
>> +        * not necessary to lock inode->i_lock.
>> +        */
>> +       rcu_assign_pointer(landlock_inode(inode)->object, NULL);
>> +       /*
>> +        * Now, new rules can safely be tied to @inode with get_inode_object().
>> +        */
>> +
>> +       iput(inode);
>> +       if (atomic_long_dec_and_test(&landlock_superblock(sb)->inode_refs))
>> +               wake_up_var(&landlock_superblock(sb)->inode_refs);
>> +}
> [...]
>> +static struct landlock_object *get_inode_object(struct inode *const inode)
>> +{
>> +       struct landlock_object *object, *new_object;
>> +       struct landlock_inode_security *inode_sec = landlock_inode(inode);
>> +
>> +       rcu_read_lock();
>> +retry:
>> +       object = rcu_dereference(inode_sec->object);
>> +       if (object) {
>> +               if (likely(refcount_inc_not_zero(&object->usage))) {
>> +                       rcu_read_unlock();
>> +                       return object;
>> +               }
>> +               /*
>> +                * We are racing with release_inode(), the object is going
>> +                * away.  Wait for release_inode(), then retry.
>> +                */
>> +               spin_lock(&object->lock);
>> +               spin_unlock(&object->lock);
>> +               goto retry;
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       /*
>> +        * If there is no object tied to @inode, then create a new one (without
>> +        * holding any locks).
>> +        */
>> +       new_object = landlock_create_object(&landlock_fs_underops, inode);
>> +       if (IS_ERR(new_object))
>> +               return new_object;
>> +
>> +       /* Protects against concurrent get_inode_object() calls. */
>> +       spin_lock(&inode->i_lock);
>> +       object = rcu_dereference_protected(inode_sec->object,
>> +                       lockdep_is_held(&inode->i_lock));
> 
> rcu_dereference_protected() requires that inode_sec->object is not
> concurrently changed, but I think another thread could call
> get_inode_object() while we're in landlock_create_object(), and then
> we could race with the NULL write in release_inode() here? (It
> wouldn't actually be a UAF though because we're not actually accessing
> `object` here.) Or am I missing a lock that prevents this?
> 
> In v28 this wasn't an issue because release_inode() was holding
> inode->i_lock (and object->lock) during the NULL store; but in v29 and
> this version the NULL store in release_inode() moved out of the locked
> region. I think you could just move the NULL store in release_inode()
> back up (and maybe add a comment explaining the locking rules for
> landlock_inode(...)->object)?
> 
> (Or alternatively you could use rcu_dereference_raw() with a comment
> explaining that the read pointer is only used to check for NULL-ness,
> and that it is guaranteed that the pointer can't change if it is NULL
> and we're holding the lock. But that'd be needlessly complicated, I
> think.)

To reach rcu_assign_pointer(landlock_inode(inode)->object, NULL) in
release_inode() or in hook_sb_delete(), the
landlock_inode(inode)->object need to be non-NULL, which implies that a
call to get_inode_object(inode) either "retry" (because release_inode is
only called by landlock_put_object, which set object->usage to 0) until
it creates a new object, or reuses the existing referenced object (and
increments object->usage). The worse case would be if
get_inode_object(inode) is called just before the
rcu_assign_pointer(landlock_inode(inode)->object, NULL) from
hook_sb_delete(), which would result in an object with a NULL underobj,
which is the expected behavior (and checked by release_inode).

The line rcu_assign_pointer(inode_sec->object, new_object) from
get_inode_object() can only be reached if the underlying inode doesn't
reference an object, in which case hook_sb_delete() will not reach the
rcu_assign_pointer(landlock_inode(inode)->object, NULL) line for this
same inode.

This works because get_inode_object(inode) is mutually exclusive to
itself with the same inode (i.e. an inode can only point to an object
that references this same inode).

I tried to explain this with the comment "Protects against concurrent
get_inode_object() calls" in get_inode_object(), and the comments just
before both rcu_assign_pointer(landlock_inode(inode)->object, NULL).

> 
> 
>> +       if (unlikely(object)) {
>> +               /* Someone else just created the object, bail out and retry. */
>> +               spin_unlock(&inode->i_lock);
>> +               kfree(new_object);
>> +
>> +               rcu_read_lock();
>> +               goto retry;
>> +       }
>> +
>> +       rcu_assign_pointer(inode_sec->object, new_object);
>> +       /*
>> +        * @inode will be released by hook_sb_delete() on its superblock
>> +        * shutdown.
>> +        */
>> +       ihold(inode);
>> +       spin_unlock(&inode->i_lock);
>> +       return new_object;
>> +}

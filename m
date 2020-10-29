Return-Path: <SRS0=kpgu=EE=lists.openwall.com=kernel-hardening-return-20303-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB318C55179
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 09:30:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB10920790
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Oct 2020 09:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB10920790
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20303-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5839 invoked by uid 550); 29 Oct 2020 09:30:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5807 invoked from network); 29 Oct 2020 09:30:18 -0000
Subject: Re: [PATCH v22 01/12] landlock: Add object management
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
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
References: <20201027200358.557003-1-mic@digikod.net>
 <20201027200358.557003-2-mic@digikod.net>
 <CAG48ez3CKa12SFHjVUPnYzJm2E7OBWnuh3JzVMrsvqdcMS1A8A@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <afa8e978-d22c-f06a-d57b-e0d1a9918062@digikod.net>
Date: Thu, 29 Oct 2020 10:30:04 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez3CKa12SFHjVUPnYzJm2E7OBWnuh3JzVMrsvqdcMS1A8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 29/10/2020 02:05, Jann Horn wrote:
> On Tue, Oct 27, 2020 at 9:04 PM Mickaël Salaün <mic@digikod.net> wrote:
>> A Landlock object enables to identify a kernel object (e.g. an inode).
>> A Landlock rule is a set of access rights allowed on an object.  Rules
>> are grouped in rulesets that may be tied to a set of processes (i.e.
>> subjects) to enforce a scoped access-control (i.e. a domain).
>>
>> Because Landlock's goal is to empower any process (especially
>> unprivileged ones) to sandbox themselves, we cannot rely on a
>> system-wide object identification such as file extended attributes.
>> Indeed, we need innocuous, composable and modular access-controls.
>>
>> The main challenge with these constraints is to identify kernel objects
>> while this identification is useful (i.e. when a security policy makes
>> use of this object).  But this identification data should be freed once
>> no policy is using it.  This ephemeral tagging should not and may not be
>> written in the filesystem.  We then need to manage the lifetime of a
>> rule according to the lifetime of its objects.  To avoid a global lock,
>> this implementation make use of RCU and counters to safely reference
>> objects.
>>
>> A following commit uses this generic object management for inodes.
>>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Reviewed-by: Jann Horn <jannh@google.com>

Thanks for the review.

> 
> except for some minor nits:
> 
> [...]
>> diff --git a/security/landlock/object.c b/security/landlock/object.c
> [...]
>> +void landlock_put_object(struct landlock_object *const object)
>> +{
>> +       /*
>> +        * The call to @object->underops->release(object) might sleep e.g.,
> 
> s/ e.g.,/, e.g./

I indeed prefer the comma preceding the "e.g.", but it seems that there
is a difference between UK english and US english:
https://english.stackexchange.com/questions/16172/should-i-always-use-a-comma-after-e-g-or-i-e
Looking at the kernel documentation makes it clear:
$ git grep -F 'e.g. ' | wc -l
1179
$ git grep -F 'e.g., ' | wc -l
160

I'll apply your fix in the whole patch series.

> 
>> +        * because of iput().
>> +        */
>> +       might_sleep();
>> +       if (!object)
>> +               return;
> [...]
>> +}
>> diff --git a/security/landlock/object.h b/security/landlock/object.h
> [...]
>> +struct landlock_object {
>> +       /**
>> +        * @usage: This counter is used to tie an object to the rules matching
>> +        * it or to keep it alive while adding a new rule.  If this counter
>> +        * reaches zero, this struct must not be modified, but this counter can
>> +        * still be read from within an RCU read-side critical section.  When
>> +        * adding a new rule to an object with a usage counter of zero, we must
>> +        * wait until the pointer to this object is set to NULL (or recycled).
>> +        */
>> +       refcount_t usage;
>> +       /**
>> +        * @lock: Guards against concurrent modifications.  This lock must be
> 
> s/must be/must be held/ ?

Right.

> 
>> +        * from the time @usage drops to zero until any weak references from
>> +        * @underobj to this object have been cleaned up.
>> +        *
>> +        * Lock ordering: inode->i_lock nests inside this.
>> +        */
>> +       spinlock_t lock;
> [...]
>> +};
>> +
>> +struct landlock_object *landlock_create_object(
>> +               const struct landlock_object_underops *const underops,
>> +               void *const underojb);
> 
> nit: "underobj"
> 

Good catch!

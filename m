Return-Path: <SRS0=vCzC=IO=lists.openwall.com=kernel-hardening-return-20946-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F75EC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 08:17:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3221E64FD9
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 08:17:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3221E64FD9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20946-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27805 invoked by uid 550); 16 Mar 2021 08:17:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27785 invoked from network); 16 Mar 2021 08:17:22 -0000
Subject: Re: [PATCH v3 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
 Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>,
 John Johansen <john.johansen@canonical.com>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20210311105242.874506-1-mic@digikod.net>
 <20210311105242.874506-2-mic@digikod.net> <202103151405.88334370F@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <041935de-83fb-5651-73d9-2ea88d4d84cc@digikod.net>
Date: Tue, 16 Mar 2021 09:17:08 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202103151405.88334370F@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 15/03/2021 22:17, Kees Cook wrote:
> On Thu, Mar 11, 2021 at 11:52:42AM +0100, Mickaël Salaün wrote:
>> [...]
>> This change may not impact systems relying on other permission models
>> than POSIX capabilities (e.g. Tomoyo).  Being able to use chroot(2) on
>> such systems may require to update their security policies.
>>
>> Only the chroot system call is relaxed with this no_new_privs check; the
>> init_chroot() helper doesn't require such change.
>>
>> Allowing unprivileged users to use chroot(2) is one of the initial
>> objectives of no_new_privs:
>> https://www.kernel.org/doc/html/latest/userspace-api/no_new_privs.html
>> This patch is a follow-up of a previous one sent by Andy Lutomirski:
>> https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/
> 
> I liked it back when Andy first suggested it, and I still like it now.
> :) I'm curious, do you have a specific user in mind for this feature?

Except for development and test purposes, being able to use root
(without CAP_SYS_CHROOT) would now enable to easily remove ambient
filesystem access. Indeed, thanks to openat2 with RESOLVE_BENEATH or
RESOLVE_IN_ROOT, it would be simple for most processes to chroot/chdir
into an empty directory after opening (or being given) file descriptors
opened with RESOLVE_BENEATH (e.g. configuration directory, cache
directory, data directory, etc.). We can get something really close to a
security capability system (different than POSIX capabilities), which
wasn't possible when Andy posted the previous patches, and can help
improve the state of userspace security.

It is already possible to limit ptrace-like attacks, even when multiple
processes are running with the same UID, with the help of SELinux, or
even simply with Yama. This already enables sysadmins or distros to
harden their system, and this kind of restrictions (with additional
access-control bits) will be available to userspace developers thanks to
Landlock.

> 
>> [...]
>> @@ -546,8 +547,18 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
>>  	if (error)
>>  		goto dput_and_out;
>>  
>> +	/*
>> +	 * Changing the root directory for the calling task (and its future
>> +	 * children) requires that this task has CAP_SYS_CHROOT in its
>> +	 * namespace, or be running with no_new_privs and not sharing its
>> +	 * fs_struct and not escaping its current root (cf. create_user_ns()).
>> +	 * As for seccomp, checking no_new_privs avoids scenarios where
>> +	 * unprivileged tasks can affect the behavior of privileged children.
>> +	 */
>>  	error = -EPERM;
>> -	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
>> +	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT) &&
>> +			!(task_no_new_privs(current) && current->fs->users == 1
>> +				&& !current_chrooted()))
>>  		goto dput_and_out;
>>  	error = security_path_chroot(&path);
>>  	if (error)
> 
> I think the logic here needs to be rearranged to avoid setting
> PF_SUPERPRIV, and I find the many negations hard to read. Perhaps:
> 
> static inline int current_chroot_allowed(void)
> {
> 	/* comment here */
> 	if (task_no_new_privs(current) && current->fs->users == 1 &&
> 	    !current_chrooted())
> 		return 0;
> 
> 	if (ns_capable(current_user_ns(), CAP_SYS_CHROOT))
> 		return 0;
> 
> 	return -EPERM;
> }
> 
> ...
> 
> 	error = current_chroot_allowed();
> 	if (error)
> 		goto dput_and_out;
> 
> 
> I can't think of a way to race current->fs->users ...
> 

OK, I would be a bit bigger patch but easier to read.

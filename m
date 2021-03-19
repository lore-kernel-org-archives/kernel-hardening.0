Return-Path: <SRS0=DUC4=IR=lists.openwall.com=kernel-hardening-return-20999-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D58EC433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:03:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 94E9C61931
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94E9C61931
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20999-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1472 invoked by uid 550); 19 Mar 2021 19:03:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1452 invoked from network); 19 Mar 2021 19:03:22 -0000
Subject: Re: [PATCH v30 02/12] landlock: Add ruleset and domain management
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-3-mic@digikod.net> <202103191114.C87C5E2B69@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <acda4be1-4076-a31d-fcfd-27764dd598c8@digikod.net>
Date: Fri, 19 Mar 2021 20:03:22 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202103191114.C87C5E2B69@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 19/03/2021 19:40, Kees Cook wrote:
> On Tue, Mar 16, 2021 at 09:42:42PM +0100, Mickaël Salaün wrote:
>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>
>> A Landlock ruleset is mainly a red-black tree with Landlock rules as
>> nodes.  This enables quick update and lookup to match a requested
>> access, e.g. to a file.  A ruleset is usable through a dedicated file
>> descriptor (cf. following commit implementing syscalls) which enables a
>> process to create and populate a ruleset with new rules.
>>
>> A domain is a ruleset tied to a set of processes.  This group of rules
>> defines the security policy enforced on these processes and their future
>> children.  A domain can transition to a new domain which is the
>> intersection of all its constraints and those of a ruleset provided by
>> the current process.  This modification only impact the current process.
>> This means that a process can only gain more constraints (i.e. lose
>> accesses) over time.
>>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>> Acked-by: Serge Hallyn <serge@hallyn.com>
>> Link: https://lore.kernel.org/r/20210316204252.427806-3-mic@digikod.net
> 
> (Aside: you appear to be self-adding your Link: tags -- AIUI, this is
> normally done by whoever pulls your series. I've only seen Link: tags
> added when needing to refer to something else not included in the
> series.)

It is an insurance to not lose history. :)

> 
>> [...]
>> +static void put_rule(struct landlock_rule *const rule)
>> +{
>> +	might_sleep();
>> +	if (!rule)
>> +		return;
>> +	landlock_put_object(rule->object);
>> +	kfree(rule);
>> +}
> 
> I'd expect this to be named "release" rather than "put" since it doesn't
> do any lifetime reference counting.

It does decrement rule->object->usage .

> 
>> +static void build_check_ruleset(void)
>> +{
>> +	const struct landlock_ruleset ruleset = {
>> +		.num_rules = ~0,
>> +		.num_layers = ~0,
>> +	};
>> +
>> +	BUILD_BUG_ON(ruleset.num_rules < LANDLOCK_MAX_NUM_RULES);
>> +	BUILD_BUG_ON(ruleset.num_layers < LANDLOCK_MAX_NUM_LAYERS);
>> +}
> 
> This is checking that the largest possible stored value is correctly
> within the LANDLOCK_MAX_* macro value?

Yes, there is builtin checks for all Landlock limits.

> 
>> [...]
> 
> The locking all looks right, and given your test coverage and syzkaller
> work, it's hard for me to think of ways to prove it out any better. :)

Thanks!

> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> 

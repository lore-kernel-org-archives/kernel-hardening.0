Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110919173905.GA3804@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
	<BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
	<CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
	<20110919173905.GA3804@albatros>
Date: Mon, 19 Sep 2011 23:17:16 +0530
Message-ID: <CAKTCnznSPoYvjzH_GekABBZ4HkyoQPVjTjBsOjwpVMSxQRxBSA@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 11:09 PM, Vasiliy Kulikov <segoon@openwall.com> wro=
te:
> On Mon, Sep 19, 2011 at 09:40 -0700, Linus Torvalds wrote:
>> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
>> index e19ce1454ee1..5874d4866b3c 100644
>> --- a/kernel/taskstats.c
>> +++ b/kernel/taskstats.c
>> @@ -457,6 +457,8 @@ static int cmd_attr_register_cpumask(struct genl_inf=
o *info)
>> =A0 =A0 =A0 cpumask_var_t mask;
>> =A0 =A0 =A0 int rc;
>>
>> + =A0 =A0 if (!capable(CAP_SYS_ADMIN))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EPERM;
>
> Shouldn't it simply protect taskstats_user_cmd()? =A0You may still poll
> the counters with TASKSTATS_CMD_ATTR_PID/TASKSTATS_CMD_ATTR_TGID.
>

Yep, it should if we want to move it all to root access.

Balbir

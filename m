References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <53a2d710-b0f0-cdf9-e7ad-cd8d03fc835a@digikod.net>
 <CAJHCu1+=uYQ-N7CH4KfmTHrN2hJjwzN0tgg4sWHU0LjVr+uGGA@mail.gmail.com>
 <c19917fa-f62c-b7e0-8cbd-f10a96f686ba@digikod.net>
 <CAJHCu1K1Hg5M2HhJxN_aj2P_S8Pez9+8KL=wHKBgAN0jN1+mLg@mail.gmail.com>
 <69ff2195-d0e1-8a0f-b80e-5d8d55947907@nmatt.com>
 <1499801476.6034.265.camel@linux.vnet.ibm.com>
 <988555a2-bed9-234c-843c-0bb68dc60d3f@nmatt.com>
 <1499959179.4220.45.camel@linux.vnet.ibm.com>
 <20170713195106.GD4895@mail.hallyn.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <6be222da-79b3-b406-53c9-10ee691bb9c6@schaufler-ca.com>
Date: Sun, 23 Jul 2017 17:58:56 -0700
MIME-Version: 1.0
In-Reply-To: <20170713195106.GD4895@mail.hallyn.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 00/11] S.A.R.A. a new stacked LSM
To: "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Matt Brown <matt@nmatt.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 7/13/2017 12:51 PM, Serge E. Hallyn wrote:
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
>> On Thu, 2017-07-13 at 08:39 -0400, Matt Brown wrote:
>> The question is really from a security perspective which is better?
>>  Obviously, as v2 of the patch set changed from using pathnames to
>> inodes, it's pretty clear that I think inodes would be better.  Kees,
>> Serge, Casey any comments?
> Yes, inode seems clearly better.  Paths are too easily worked around.

An inode identifies the object, while a pathname identifies the intent.
Using the inode will be easier to code and easier to model. Using the
pathname will be much more likely to reflect what the human means to
accomplish, provided all the idiosyncrasies of the Linux filesystem
namespace are taken into account. Ever since the link count on an inode
was allowed to exceed 1* this has been difficult to accomplish.

----
* The link count has always been allowed to exceed 1. Then there
  are symlinks, mount points, overlay filesystems and all manner
  of other slick features that make the filesystem namespace
  difficult to deal with from the security standpoint.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

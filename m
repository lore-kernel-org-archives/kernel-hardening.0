MIME-Version: 1.0
In-Reply-To: <CAHC9VhSLtG8GdjH2uPv-Ch_YSs8_AGbTBBn5+owL=6C+L83p-g@mail.gmail.com>
References: <alpine.LRH.2.20.1702131634430.8914@namei.org> <CAHC9VhSLtG8GdjH2uPv-Ch_YSs8_AGbTBBn5+owL=6C+L83p-g@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Feb 2017 16:15:02 -0500
Message-ID: <CAHC9VhRXkU6wajgL2P+FaHf=5R=619wyHwWgfbvZm0JhTUuw5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 4/4] selinux: constify nlmsg permission tables
To: selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 13, 2017 at 7:19 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Mon, Feb 13, 2017 at 12:35 AM, James Morris <jmorris@namei.org> wrote:
>> Constify nlmsg permission tables, which are initialized once
>> and then do not change.
>>
>> Signed-off-by: James Morris <james.l.morris@oracle.com>
>> ---
>>  security/selinux/nlmsgtab.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> The SELinux list should have been CC'd on this patch - come on James,
> you know better ;)
>
> Normally I push patches this close to the merge window out until after
> the merge window, but this is trivial and easily verified by the
> compiler so I've merged this.
>
> James, if you want to grab it for v4.11 you can pull from the tree below:
>
> git://git.infradead.org/users/pcmoore/selinux stable-4.11

It doesn't appear that James picked this up for v4.11 so I've moved it
from the selinux/stable-4.11 branch to the selinux/next branch.  We'll
get it upstream during the next merge window.

>> diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
>> index 2ca9cde..57e2596 100644
>> --- a/security/selinux/nlmsgtab.c
>> +++ b/security/selinux/nlmsgtab.c
>> @@ -28,7 +28,7 @@ struct nlmsg_perm {
>>         u32     perm;
>>  };
>>
>> -static struct nlmsg_perm nlmsg_route_perms[] =
>> +static const struct nlmsg_perm nlmsg_route_perms[] =
>>  {
>>         { RTM_NEWLINK,          NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>>         { RTM_DELLINK,          NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
>> @@ -80,7 +80,7 @@ struct nlmsg_perm {
>>         { RTM_GETSTATS,         NETLINK_ROUTE_SOCKET__NLMSG_READ  },
>>  };
>>
>> -static struct nlmsg_perm nlmsg_tcpdiag_perms[] =
>> +static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
>>  {
>>         { TCPDIAG_GETSOCK,      NETLINK_TCPDIAG_SOCKET__NLMSG_READ },
>>         { DCCPDIAG_GETSOCK,     NETLINK_TCPDIAG_SOCKET__NLMSG_READ },
>> @@ -88,7 +88,7 @@ struct nlmsg_perm {
>>         { SOCK_DESTROY,         NETLINK_TCPDIAG_SOCKET__NLMSG_WRITE },
>>  };
>>
>> -static struct nlmsg_perm nlmsg_xfrm_perms[] =
>> +static const struct nlmsg_perm nlmsg_xfrm_perms[] =
>>  {
>>         { XFRM_MSG_NEWSA,       NETLINK_XFRM_SOCKET__NLMSG_WRITE },
>>         { XFRM_MSG_DELSA,       NETLINK_XFRM_SOCKET__NLMSG_WRITE },
>> @@ -115,7 +115,7 @@ struct nlmsg_perm {
>>         { XFRM_MSG_MAPPING,     NETLINK_XFRM_SOCKET__NLMSG_READ  },
>>  };
>>
>> -static struct nlmsg_perm nlmsg_audit_perms[] =
>> +static const struct nlmsg_perm nlmsg_audit_perms[] =
>>  {
>>         { AUDIT_GET,            NETLINK_AUDIT_SOCKET__NLMSG_READ     },
>>         { AUDIT_SET,            NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
>> @@ -136,7 +136,7 @@ struct nlmsg_perm {
>>  };
>>
>>
>> -static int nlmsg_perm(u16 nlmsg_type, u32 *perm, struct nlmsg_perm *tab, size_t tabsize)
>> +static int nlmsg_perm(u16 nlmsg_type, u32 *perm, const struct nlmsg_perm *tab, size_t tabsize)
>>  {
>>         int i, err = -EINVAL;
>>

-- 
paul moore
www.paul-moore.com

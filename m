Date: Thu, 18 Jan 2018 03:06:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180118030634.GY13338@ZenIV.linux.org.uk>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
 <20180117185232.GW13338@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180117185232.GW13338@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] [RFC][PATCH] get rid of the use of set_fs() (by way of
 kernel_recvmsg()) in sunrpc
To: netdev@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 06:52:32PM +0000, Al Viro wrote:

[use of set_fs() by sunrpc]
> We are asking for recvmsg() with zero data length; what we really want is
> ->msg_control.  And _that_ is why we need that set_fs() - we want the damn
> thing to go into local variable.
> 
> But note that filling ->msg_control will happen in put_cmsg(), called
> from ip_cmsg_recv_pktinfo(), called from ip_cmsg_recv_offset(),
> called from udp_recvmsg(), called from sock_recvmsg_nosec(), called
> from sock_recvmsg().  Or in another path in case of IPv6.
> Sure, we can arrange for propagation of that all way down those
> call chains.  My preference would be to try and mark that (one and
> only) case in ->msg_flags, so that put_cmsg() would be able to
> check.  ___sys_recvmsg() sets that as
>         msg_sys->msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
> so we ought to be free to use any bit other than those two.  Since
> put_cmsg() already checks ->msg_flags, that shouldn't put too much
> overhead.

Folks, does anybody have objections against the following:

Get rid of kernel_recvmsg() (and thus set_fs()) use in sunrpc

In net/sunrpc/svcsock.c:svc_udp_recvfrom() we want to get
IP_PKTINFO; currently we stash the address of local variable
into ->msg_control (which normall contains a userland pointer
in recepients) and issue zero-length ->recvmsg() under
set_fs(KERNEL_DS).

Similar to the way put_cmsg() handles 32bit case on biarch
targets, introduce a flag telling put_cmsg() to treat
->msg_control as kernel pointer, using memcpy instead of
copy_to_user().  That allows to avoid the use of kernel_recvmsg()
with its set_fs().

All places that might have non-NULL ->msg_control either pass the
msghdr only to ->sendmsg() and its ilk, or have ->msg_flags
sanitized before passing msghdr anywhere.  IOW, there no
way the new flag to reach put_cmsg() in the mainline kernel,
and after this change it will only be seen in sunrpc case.

Incidentally, all other kernel_recvmsg() users are very easy to
convert to sock_recvmsg(), so that would allow to kill
kernel_recvmsg() off...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 9286a5a8c60c..60947da9c806 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -298,6 +298,7 @@ struct ucred {
 #else
 #define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
 #endif
+#define MSG_CMSG_KERNEL	0x10000000
 
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
diff --git a/net/core/scm.c b/net/core/scm.c
index b1ff8a441748..1b73b682e441 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -237,10 +237,17 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	cmhdr.cmsg_len = cmlen;
 
 	err = -EFAULT;
-	if (copy_to_user(cm, &cmhdr, sizeof cmhdr))
-		goto out;
-	if (copy_to_user(CMSG_DATA(cm), data, cmlen - sizeof(struct cmsghdr)))
-		goto out;
+	if (unlikely(MSG_CMSG_KERNEL & msg->msg_flags)) {
+		struct cmsghdr *p = msg->msg_control;
+		memcpy(p, &cmhdr, sizeof cmhdr);
+		memcpy(CMSG_DATA(p), data, cmlen - sizeof(struct cmsghdr));
+	} else {
+		if (copy_to_user(cm, &cmhdr, sizeof cmhdr))
+			goto out;
+		if (copy_to_user(CMSG_DATA(cm), data,
+				 cmlen - sizeof(struct cmsghdr)))
+			goto out;
+	}
 	cmlen = CMSG_SPACE(len);
 	if (msg->msg_controllen < cmlen)
 		cmlen = msg->msg_controllen;
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 5570719e4787..774904f67c93 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -545,7 +545,7 @@ static int svc_udp_recvfrom(struct svc_rqst *rqstp)
 		.msg_name = svc_addr(rqstp),
 		.msg_control = cmh,
 		.msg_controllen = sizeof(buffer),
-		.msg_flags = MSG_DONTWAIT,
+		.msg_flags = MSG_DONTWAIT | MSG_CMSG_KERNEL,
 	};
 	size_t len;
 	int err;
@@ -565,8 +565,7 @@ static int svc_udp_recvfrom(struct svc_rqst *rqstp)
 
 	clear_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
 	skb = NULL;
-	err = kernel_recvmsg(svsk->sk_sock, &msg, NULL,
-			     0, 0, MSG_PEEK | MSG_DONTWAIT);
+	err = sock_recvmsg(svsk->sk_sock, &msg, MSG_PEEK | MSG_DONTWAIT);
 	if (err >= 0)
 		skb = skb_recv_udp(svsk->sk_sk, 0, 1, &err);
 

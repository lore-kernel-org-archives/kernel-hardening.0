Date: Sun, 9 Dec 2018 21:56:51 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v1] copy_{to,from}_user(): only inline when !__CHECKER__
Message-ID: <20181209215651.GD2217@ZenIV.linux.org.uk>
References: <20181209204449.18906-1-tycho@tycho.ws>
 <20181209210220.GB2217@ZenIV.linux.org.uk>
 <20181209212523.GE30796@cisco>
 <20181209213951.kumz33u6prb2seqz@ltop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181209213951.kumz33u6prb2seqz@ltop.local>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Tycho Andersen <tycho@tycho.ws>, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 09, 2018 at 10:39:52PM +0100, Luc Van Oostenryck wrote:

> There are several more or less bad/good solutions, like:
> * add raw_copy_{to,from}_user() in the list of checked function
>   (not inlined in most archs).
> * add a new annotation to force sparse to check the byte count
>   (I'm thinking about __range__/OP_RANGE or something similar).
> * do these checks before functions are inlined (but then some
>   constant count could not yet be seen as constant).
  * just spell it out in copy_to_user() itself - as in
#ifdef C_T_U_SIZE_LIMIT
	if (__builtin_constant_p(count) && count > C_T_U_SIZE_LIMIT)
		/* something warning-triggering */
#endif
in the beginning of copy_from_user().  Or simply
#ifdef C_T_U_SIZE_LIMIT
	BUILD_BUG_ON(__builtin_constant_p(count) && count > C_T_U_SIZE_LIMIT);
#endif
in there...

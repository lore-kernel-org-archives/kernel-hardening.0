Subject: Re: [PATCH v2] ima: drop vla in ima_audit_measurement()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2018 15:36:14 -0500
In-Reply-To: <20180308202347.31331-1-tycho@tycho.ws>
References: <20180308202347.31331-1-tycho@tycho.ws>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1520541374.3605.101.camel@linux.vnet.ibm.com>
To: Tycho Andersen <tycho@tycho.ws>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2018-03-08 at 13:23 -0700, Tycho Andersen wrote:

>  /*
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 2cfb0c714967..356faae6f09c 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -288,8 +288,11 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
>  					      xattr_value, xattr_len, opened);
>  		inode_unlock(inode);
>  	}
> -	if (action & IMA_AUDIT)
> -		ima_audit_measurement(iint, pathname);
> +	if (action & IMA_AUDIT) {
> +		rc = ima_audit_measurement(iint, pathname);
> +		if (rc < 0)
> +			goto out_locked;
> +	}
> 
>  	if ((file->f_flags & O_DIRECT) && (iint->flags & IMA_PERMIT_DIRECTIO))
>  		rc = 0;

Only when IMA-appraisal is enforcing file data integrity should
process_measurement() ever fail.  Other errors can be logged/audited.

Mimi

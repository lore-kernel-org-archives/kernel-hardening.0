Date: Thu, 8 Mar 2018 14:45:47 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2] ima: drop vla in ima_audit_measurement()
Message-ID: <20180308214547.kdeoeozugxffzumn@smitten>
References: <20180308202347.31331-1-tycho@tycho.ws>
 <1520541374.3605.101.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1520541374.3605.101.camel@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mimi,

On Thu, Mar 08, 2018 at 03:36:14PM -0500, Mimi Zohar wrote:
> On Thu, 2018-03-08 at 13:23 -0700, Tycho Andersen wrote:
> 
> >  /*
> > diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> > index 2cfb0c714967..356faae6f09c 100644
> > --- a/security/integrity/ima/ima_main.c
> > +++ b/security/integrity/ima/ima_main.c
> > @@ -288,8 +288,11 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
> >  					      xattr_value, xattr_len, opened);
> >  		inode_unlock(inode);
> >  	}
> > -	if (action & IMA_AUDIT)
> > -		ima_audit_measurement(iint, pathname);
> > +	if (action & IMA_AUDIT) {
> > +		rc = ima_audit_measurement(iint, pathname);
> > +		if (rc < 0)
> > +			goto out_locked;
> > +	}
> > 
> >  	if ((file->f_flags & O_DIRECT) && (iint->flags & IMA_PERMIT_DIRECTIO))
> >  		rc = 0;
> 
> Only when IMA-appraisal is enforcing file data integrity should
> process_measurement() ever fail.  Other errors can be logged/audited.

Ok, so previously in ima_audit_measurement() when allocation failed,
there was nothing logged. If we just keep this behavior like below,
does that look good?

Thanks!

Tycho

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 356faae6f09c..4e699bc7adc5 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -289,9 +289,13 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 		inode_unlock(inode);
 	}
 	if (action & IMA_AUDIT) {
-		rc = ima_audit_measurement(iint, pathname);
-		if (rc < 0)
+		int ret;
+
+		ret = ima_audit_measurement(iint, pathname);
+		if (ret < 0 && ima_appraise & IMA_APPRAISE_ENFORCE) {
+			rc = ret;
 			goto out_locked;
+		}
 	}
 
 	if ((file->f_flags & O_DIRECT) && (iint->flags & IMA_PERMIT_DIRECTIO))

From: James Bottomley <jejb@linux.vnet.ibm.com>
Date: Thu, 11 Jan 2018 17:19:16 -0800
In-Reply-To: <151571807774.27429.7382333750792304971.stgit@dwillia2-desk3.amr.corp.intel.com>
References: 
	<151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <151571807774.27429.7382333750792304971.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1515719956.3056.37.camel@linux.vnet.ibm.com>
Subject: [kernel-hardening] Re: [PATCH v2 17/19] qla2xxx: prevent bounds-check bypass via
 speculative execution
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, qla2xxx-upstream@qlogic.com, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2018-01-11 at 16:47 -0800, Dan Williams wrote:
> Static analysis reports that 'handle' may be a user controlled value
> that is used as a data dependency to read 'sp' from the
> 'req->outstanding_cmds' array.

Greg already told you it comes from hardware, specifically the hardware
response queue.  If you don't believe him, I can confirm it's quite
definitely all copied from the iomem where the mailbox response is, so
it can't be a user controlled value (well, unless the user has some
influence over the firmware of the qla2xxx  controller, which probably
means you have other things to worry about than speculative information
leaks).

I think what it actually is is a handle returned in the mailbox that's
used to find other mailbox entries in different queues (the packet
handle actually contains an entry in the lower 16 bits and a queue
designation in the upper).  Perhaps the qla2xxx people should comment
on this because the code seems to check and print an error if there's a
problem with the handle being too big, but we don't check the que value
and use it blindly to read into the req_q_map: if handle could be
wrong, couldn't que?

James
